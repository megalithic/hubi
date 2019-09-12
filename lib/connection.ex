defmodule Hubi.Connection do
  use GenServer

  require Logger

  defstruct [:conn, requests: %{}]

  def start_link({scheme, host, port}) do
    GenServer.start_link(__MODULE__, {scheme, host, port})
  end

  def request(pid, method, path, headers, body) do
    GenServer.call(pid, {:request, method, path, headers, body})
  end

  ## Callbacks

  @impl true
  def init({scheme, host, port}) do
    with {:ok, conn} <- Mint.HTTP.connect(scheme, host, port) do
      state = %__MODULE__{conn: conn}
      {:ok, state}
    end
  end

  @impl true
  def handle_call({:request, method, path, headers, body}, from, state) do
    # In both the successful case and the error case, we make sure to update the connection
    # struct in the state since the connection is an immutable data structure.
    case Mint.HTTP.request(state.conn, method, path, headers, body) do
      {:ok, conn, request_ref} ->
        state = put_in(state.conn, conn)
        # We store the caller this request belongs to and an empty map as the response.
        # The map will be filled with status code, headers, and so on.
        state = put_in(state.requests[request_ref], %{from: from, response: %{}})
        {:noreply, state}

      {:error, conn, reason} ->
        state = put_in(state.conn, conn)
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_info(message, state) do
    # We should handle the error case here as well, but we're omitting it for brevity.
    case Mint.HTTP.stream(state.conn, message) do
      :unknown ->
        _ = Logger.error(fn -> "Received unknown message: " <> inspect(message) end)
        {:noreply, state}

      {:ok, conn, responses} ->
        state = put_in(state.conn, conn)
        state = Enum.reduce(responses, state, &process_response/2)
        {:noreply, state}
    end
  end

  defp process_response({:status, request_ref, status}, state) do
    put_in(state.requests[request_ref].response[:status], status)
  end

  defp process_response({:headers, request_ref, headers}, state) do
    put_in(state.requests[request_ref].response[:headers], headers)
  end

  defp process_response({:data, request_ref, new_data}, state) do
    update_in(state.requests[request_ref].response[:data], fn data -> (data || "") <> new_data end)
  end

  # Returns a list of found compressions or [] if none found.
  defp get_content_encoding_header(headers) do
    Enum.find_value(headers, [], fn {name, value} ->
      if String.downcase(name) == "content-encoding" do
        value
        |> String.downcase()
        |> String.split(",", trim: true)
        |> Stream.map(&String.trim/1)
        |> Enum.reverse()
      else
        nil
      end
    end)
  end

  defp decompress_data(data, algorithms) do
    Enum.reduce(algorithms, data, &decompress_with_algorithm/2)
  end

  defp decompress_with_algorithm(gzip, data) when gzip in ["gzip", "x-gzip"],
    do: :zlip.gunzip(data)

  defp decompress_with_algorithm("deflate", data),
    do: :zlib.unzip(data)

  defp decompress_data("identity", data),
    do: data

  defp decompress_data(algorithm, data),
    do: raise("unsupported decompression algorithm: #{inspect(algorithm)}")

  defp process_response({:done, request_ref}, state) do
    {%{response: response, from: from}, state} = pop_in(state.requests[request_ref])

    # Handle compression here.
    compression_algorithms = get_content_encoding_header(response.headers)
    response = update_in(response.data, &decompress_data(&1, compression_algorithms))

    GenServer.reply(from, {:ok, response})

    state
  end
end
