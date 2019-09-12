defmodule Hubi.CLI do
  @moduledoc false

  use ExCLI.DSL, escript: true

  alias Hubi

  name "hubi"
  description "Hubi CLI"

  long_description ~s"""
  Hubi CLI script for Hubitat interactions
  """

  option :verbose, count: true, aliases: [:v]

  command :devices do
    aliases [:list, :ls]
    description "Device listing"

    long_description """
    Gets and displays a list of devices on your Hubitat hub
    """

    run context do
      if context.verbose > 0 do
        IO.puts("Running device listing command..")
      end

      {:ok, devices} = Hubi.devices()
      IO.inspect(devices)
    end
  end

  command :status do
    aliases [:device]
    description "Device Status/Info"

    long_description """
    Gets and displays the status/info about a device
    """

    argument(:device_id)

    run context do
      if context.verbose > 0 do
        IO.puts("Running device get command for #{context.device_id}..")
      end

      {:ok, device} = Hubi.device(context.device_id)
      IO.inspect(device)
    end
  end
end
