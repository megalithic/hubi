defmodule Hubi.CLI do
  @moduledoc false

  use ExCLI.DSL, escript: true

  alias Hubi
  # alias Hubi.Device

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

      Scribe.print(devices,
        style: Scribe.Style.Pseudo,
        data: [
          {"Device ID", fn row -> String.to_integer(row["id"]) end},
          {"Label", fn row -> row["label"] end},
          {"Name", fn row -> row["name"] end}
        ]
      )
    end
  end

  command :device do
    aliases [:status]
    description "Device Status/Info (requires <device_id>)"

    long_description """
    Gets and displays the status/info about a device
    """

    argument(:device_id)

    run context do
      if context.verbose > 0 do
        IO.puts("Running device get command for #{context.device_id}..")
      end

      {:ok,
       %{meta: meta, commands: commands, capabilities: capabilities, attributes: attributes} =
         _device} = Hubi.device(context.device_id)

      Scribe.print(meta,
        style: Scribe.Style.Pseudo,
        data: [
          {"Device ID", fn %{id: id} -> id end},
          {"Label", fn %{label: label} -> label end},
          {"Name", fn %{name: name} -> name end}
        ]
      )

      Scribe.print(commands,
        style: Scribe.Style.Pseudo,
        data: [
          {"Supported Commands", fn %{commands: commands} -> commands end}
        ]
      )

      Scribe.print(attributes,
        style: Scribe.Style.Pseudo,
        data: [
          {"Name", fn %{"name" => name} -> name end},
          {"Type", fn %{"dataType" => type} -> type end},
          {"Value", fn %{"currentValue" => value} -> value end}
        ]
      )

      # Device.print(meta)

      # Scribe.print(capabilities, style: Scribe.Style.Pseudo)

      IO.inspect(capabilities, label: "--------------------------- capabilities: ")
      # IO.inspect(attributes, label: "--------------------------- attributes: ")
    end
  end
end
