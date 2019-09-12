defmodule Hubi.Mixfile do
  @moduledoc false

  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :hubi,
      version: @version,
      elixir: "~> 1.9.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      escript: [main_module: Hubi.CLI],
      description: "CLI tool to interface with your local Hubitat hub install",
      source_url: "https://github.com/megalithic/hubi",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [source_ref: "#{@version}", extras: ["README.md"], main: "readme"]
    ]
  end

  defp elixirc_paths(:dev), do: elixirc_paths(:test)
  defp elixirc_paths(:test), do: ["sample", "lib"]
  defp elixirc_paths(_all), do: ["lib"]

  def application do
    [applications: applications(Mix.env())]
  end

  defp applications(:test) do
    applications(:all) ++ [:hackney]
  end

  defp applications(_all) do
    [:logger]
  end

  def deps do
    [
      {:ex_cli, "~> 0.1.2"},
      {:credo, "~> 0.8.10", only: [:dev, :test]},
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.14.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:tesla, "~> 1.2.1"}
    ]
  end
end
