defmodule Hubi do
  alias Hubi.Device

  @hubitat_ip System.get_env("HUBITAT_LAN")
  @hubitat_app_id System.get_env("HUBITAT_APP_ID_MAKER")
  @hubitat_token System.get_env("HUBITAT_TOKEN")
  @default_headers [{"authorization", "Bearer #{@hubitat_token}"}]

  def devices do
    endpoint = "http://#{@hubitat_ip}/apps/api/#{@hubitat_app_id}/devices"

    ProgressBar.render_spinner(
      [
        frames: :braille,
        text: "Loading Devices…",
        spinner_color: IO.ANSI.magenta(),
        done: [IO.ANSI.green(), "✓", IO.ANSI.reset(), " Loaded Devices."]
      ],
      fn ->
        with {:ok, %HTTP.Response{status_code: 200} = resp} <-
               HTTP.get(endpoint, @default_headers),
             {:ok, devices} <- Jason.decode(resp.body) do
          # {:ok, devices} <- Base.decode64(json, ignore: :whitespace) do
          {:ok, devices}
        else
          err -> {:error, err}
        end
      end
    )
  end

  def device(id) do
    endpoint = "http://#{@hubitat_ip}/apps/api/#{@hubitat_app_id}/devices/#{id}"

    ProgressBar.render_spinner(
      [
        frames: :braille,
        text: "Loading Device (#{id})…",
        spinner_color: IO.ANSI.magenta(),
        done: [IO.ANSI.green(), "✓", IO.ANSI.reset(), " Loaded Device."]
      ],
      fn ->
        with {:ok, %HTTP.Response{status_code: 200} = resp} <-
               HTTP.get(endpoint, @default_headers),
             {:ok, device} <- Jason.decode(resp.body) do
          # {:ok, devices} <- Base.decode64(json, ignore: :whitespace) do
          {:ok, Device.format(device)}
        else
          err -> {:error, err}
        end
      end
    )
  end
end
