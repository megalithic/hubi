defmodule Hubitat.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :hubitat,
     version: @version,
     elixir: "~> 1.8",
     elixirc_paths: elixirc_paths(Mix.env),
     description: "CLI tool to interface with your local Hubitat hub install",
     source_url: "https://github.com/megalithic/hubitat",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [source_ref: "#{@version}", extras: ["README.md"], main: "readme"]]
  end

  defp elixirc_paths(:dev),  do: elixirc_paths(:test)
  defp elixirc_paths(:test), do: ["sample", "lib"]
  defp elixirc_paths(_all),  do: ["lib"]


  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:test) do
    applications(:all) ++ [:hackney]
  end

  defp applications(_all) do
    [:logger]
  end

  def deps do
    [{:ex_cli, "~> 0.1.0"}]
  end
end
