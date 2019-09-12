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

      IO.inspect(Hubi.devices(), label: "devices.........")
    end
  end
end
