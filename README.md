# terraform [![Hex](https://img.shields.io/hexpm/v/terraform.svg)](https://hex.pm/packages/terraform) [![Build Status](https://travis-ci.com/poteto/terraform.svg?branch=master)](https://travis-ci.com/poteto/terraform) ![Phoenix compatibility](https://img.shields.io/badge/phoenix%20compat-%3E%3D%201.2.0%20and%20%3C%3D%201.5.x-blue)

Terraform is a simple `Plug` designed to work with Phoenix. Terraform allows you to incrementally transform a HTTP API into one powered by Phoenix - one endpoint at a time.

View the [demo Phoenix app](https://github.com/poteto/reverse_proxy).

## Phoenix Compatibility

This package is explicitly tested against the following Phoenix versions:

| Phoenix version  | Compatibility |
| ------------- | ------------- |
| ~> 1.2.0  | ✅  |
| ~> 1.3.0  | ✅  |
| ~> 1.4.0  | ✅  |
| ~> 1.5.0  | ✅  |

## Installation

Add `terraform` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:terraform, "~> 1.0.1"}]
end
```

## Usage

First, add it to `web/router.ex`:

```elixir
defmodule MyApp.Router do
  use Terraform, terraformer: MyApp.Terraformers.Foo

  # ...
end
```

Then, define a new `Terraformer`, which uses `Plug.Router`. Any request that goes to a route that isn't defined on your Phoenix app will hit this plug, and you can then handle it using a familiar DSL. Refer to [hexdocs](https://hexdocs.pm/plug/Plug.Router.html) for documentation about `Plug.Router`.

Here's a basic example:

```elixir
defmodule MyApp.Terraformers.Foo do
  alias MyApp.Clients.Foo # example client made with HTTPoison
  use Plug.Router

  plug :match
  plug :dispatch

  # match specific path
  get "/v1/hello-world", do: send_resp(conn, 200, "Hello world")

  # match all `get`s
  get _ do
    %{method: "GET", request_path: request_path, params: params, req_headers: req_headers} = conn
    res = Foo.get!(request_path, req_headers, [params: Map.to_list(params)])
    send_response({:ok, conn, res})
  end

  def send_response({:ok, conn, %{headers: headers, status_code: status_code, body: body}}) do
    conn = %{conn | resp_headers: headers}
    send_resp(conn, status_code, body)
  end
end
```

### Reading the request body

`Plug` has an elegant solution to this problem using [`Plug.Conn.read_body`](https://hexdocs.pm/plug/Plug.Conn.html#read_body/2). Refer to this [comment](https://github.com/phoenixframework/phoenix/issues/459#issuecomment-440820663) for details.
