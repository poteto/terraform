# terraform [![CircleCI](https://circleci.com/gh/poteto/terraform/tree/master.svg?style=svg)](https://circleci.com/gh/poteto/terraform/tree/master)

Terraform is an Elixir library designed to work with Phoenix. Terraform allows you to incrementally transform an older API into one powered by Phoenix - one endpoint at a time. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `terraform` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:terraform, "~> 0.1.0"}]
    end
    ```

  2. Ensure `terraform` is started before your application:

    ```elixir
    def application do
      [applications: [:terraform]]
    end
    ```

