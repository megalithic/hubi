defmodule Hubi.Device do
  def format(device) do
    formatted_device =
      device
      |> map_string_to_atom
      |> get_meta
      |> get_attributes
      |> get_commands
      |> get_capabilities

    formatted_device
  end

  def print(data) do
    IO.inspect(data, label: 'initial data -----------------------------')

    case data do
      %{meta: meta} ->
        IO.inspect(meta, label: "meta")
        Scribe.print(meta,
          style: Scribe.Style.Pseudo,
          data: [
            {"Device ID", fn %{id: id} -> id end},
            {"Label", fn %{label: label} -> label end},
            {"Name", fn %{name: name} -> name end}
          ]
        )

      %{commands: commands} ->
        IO.inspect(commands, label: "commands")
        Scribe.print(commands,
          style: Scribe.Style.Pseudo,
          data: [
            {"Supported Commands", fn %{commands: commands} -> commands end}
          ]
        )

      %{attributes: attributes} ->
        Scribe.print(attributes,
          style: Scribe.Style.Pseudo,
          data: [
            {"Name", fn %{"name" => name} -> name end},
            {"Type", fn %{"dataType" => type} -> type end},
            {"Value", fn %{"currentValue" => value} -> value end}
          ]
        )

      _ ->
        IO.inspect(data)
    end
  end

  defp map_string_to_atom(device) do
    device
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end

  defp get_meta(%{id: id, name: name, label: label} = device) do
    Map.put(device, :meta, %{id: String.to_integer(id), name: name, label: label})
  end

  defp get_commands(%{commands: commands} = device) do
    Map.put(device, :commands, %{commands: commands})
  end

  defp get_capabilities(%{capabilities: capabilities} = device) do
    Map.put(device, :capabilities, capabilities)
  end

  defp get_attributes(%{attributes: attributes} = device) do
    Map.put(device, :attributes, attributes)
  end
end
