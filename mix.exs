defmodule Terraform.Mixfile do
  use Mix.Project

  def project do
    [app: :terraform,
     version: "0.0.0",
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
      maintainers: ["Lauren Tan"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/poteto/terraform"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end
end
