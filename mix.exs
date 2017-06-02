defmodule Terraform.Mixfile do
  use Mix.Project

  def project do
    [app: :terraform,
     version: "1.0.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     description: description(),
     package: package(),
     deps: deps()]
  end

  def description do
    """
    Incrementally replace an old API with Phoenix.
    """
  end

  def package do
    [
      maintainers: ["Lauren Tan", "Dan McClain"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/poteto/terraform"}
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, github: "elixir-lang/ex_doc", only: [:dev]},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
     {:credo, "~> 0.7", only: [:dev, :test]},
     {:phoenix, ">= 1.2.0 and < 2.0.0 or ~> 1.3.0-rc"}]
  end

  defp aliases do
    ["test.lint": ["credo --strict"]]
  end
end
