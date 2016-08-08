# terraform [![CircleCI](https://circleci.com/gh/poteto/terraform/tree/master.svg?style=svg)](https://circleci.com/gh/poteto/terraform/tree/master)

Terraform is an Elixir library designed to work with Phoenix. Terraform allows you to incrementally transform an older API into one powered by Phoenix - one endpoint at a time.

View the [demo Phoenix app](https://github.com/poteto/reverse_proxy).

## Installation

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

## Usage

First, add it to `web/router.ex`:

```elixir
defmodule MyApp.Router do
  use Terraform.Discovery,
    terraformer: MyApp.Terraformers.Foo

  # ...
end
```

Then, define a new `Terraformer`, which is also a `Plug`:

```elixir
defmodule MyApp.Terraformers.Foo do
  # example client made with HTTPoison
  alias MyApp.Clients.Foo
  import Plug.Conn
  import Terraform, only: [send_response: 1]
  
  def init(opts), do: opts

  # match specific path
  def call(%{method: "GET", request_path: "/v1/hello-world"} = conn, _) do
    send_resp(conn, 200, "Hello world")
  end
  # match all `get`s
  def call(%{method: "GET", params: params, req_headers: req_headers} = conn, _) do
    res = Foo.get!(path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end
end
```
