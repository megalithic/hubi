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
