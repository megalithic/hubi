defmodule Hubi do
  @hubitat_ip System.get_env("HUBITAT_LAN")
  @hubitat_app_id System.get_env("HUBITAT_APP_ID_MAKER")
  @hubitat_token System.get_env("HUBITAT_TOKEN")
  @default_headers [{"authorization", "Bearer #{@hubitat_token}"}]

  def devices() do
    endpoint = "http://#{@hubitat_ip}/apps/api/#{@hubitat_app_id}/devices"

    with {:ok, %HTTP.Response{status_code: 200} = resp} <-
           HTTP.get(endpoint, @default_headers),
         {:ok, devices} <- Jason.decode(resp.body) do
      # {:ok, devices} <- Base.decode64(json, ignore: :whitespace) do
      {:ok, devices}
    else
      err -> {:error, err}
    end
  end

  def device(id) do
    endpoint = "http://#{@hubitat_ip}/apps/api/#{@hubitat_app_id}/devices/#{id}"

    with {:ok, %HTTP.Response{status_code: 200} = resp} <-
           HTTP.get(endpoint, @default_headers),
         {:ok, device} <- Jason.decode(resp.body) do
      # {:ok, devices} <- Base.decode64(json, ignore: :whitespace) do
      {:ok, device}
    else
      err -> {:error, err}
    end
  end
end
