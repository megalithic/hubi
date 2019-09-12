defmodule Hubi.Application do
  @moduledoc false

  use Application

  @hubitat_ip System.get_env("HUBITAT_LAN")
  # @hubitat_app_id System.get_env("HUBITAT_APP_ID_MAKER")
  # @hubitat_token System.get_env("HUBITAT_TOKEN")

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Hubi.Connection, [{:http, @hubitat_ip, 80}])
    ]

    opts = [strategy: :one_for_one, name: Hubi.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
