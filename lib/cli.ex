defmodule Hubi.Cli do
  use ExCLI.DSL

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

    argument :device_name
    # option :from, help: "the sender of hello"

    run context do
      if context.verbose > 0 do
        IO.puts("Running device listing command..")
      end
      # if from = context[:from] do
      #   IO.write("#{from} says: ")
      # end
      IO.puts("Hello #{context.device_name}!")
    end
  end
end

ExCLI.run!(Hubi.Cli)
