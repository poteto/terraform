defmodule Terraform.Mixfile do
  use Mix.Project

  def project do
    [app: :terraform,
     version: "0.1.2",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
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
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, github: "elixir-lang/ex_doc", only: :dev},
     {:phoenix, "~> 1.2.0"}]
  end
end
