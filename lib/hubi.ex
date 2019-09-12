defmodule Hubi do
  use Tesla, only: [:get], docs: false

  plug(Tesla.Middleware.BaseUrl, "http://#{config.hubitat_ip}")
  plug(Tesla.Middleware.Query, access_token: config.hubitat_token)
  plug(Tesla.Middleware.Logger)
  plug(Tesla.Middleware.PathParams)
  plug(Tesla.Middleware.JSON)

  def devices() do
    get("/apps/api/#{config().hubitat_app_id}/devices")
  end

  def device(id) do
    params = [id: id]
    get("/apps/api/#{config().hubitat_app_id}/devices/:id", opts: [path_params: params])
  end

  defp config do
    %{
      hubitat_ip: System.get_env("HUBITAT_LAN"),
      hubitat_app_id: System.get_env("HUBITAT_APP_ID_MAKER"),
      hubitat_token: System.get_env("HUBITAT_TOKEN")
    }
  end
end
