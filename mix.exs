defmodule Adventofcode.MixProject do
  use Mix.Project


  def project do
    [
      app: :adventofcode,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        output: "docs"
      ],
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: [fastutils: []]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:matrex, "~> 0.6"},
      {:libgraph, "~> 0.13"},
      {:flow, "~> 0.14"},
      {:memoize, "~> 1.2"},
      {:combine, "~> 0.10.0"},
      {:color_utils, "0.2.0"},
      {:comb, git: "https://github.com/tallakt/comb.git"},
      {:remix, "~> 0.0.1", only: :dev},
      {:rustler, "~> 0.21.1"}
    ]
  end
end
