defmodule TerraformTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest Terraform

  defmodule DummyTerraformer do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/bar" do
      send_resp(conn, 200, "bar")
    end

    match _ do
      send_resp(conn, 200, "catchall")
    end
  end

  defmodule FooController do
    use Phoenix.Controller

    def index(conn, _) do
      send_resp(conn, 200, "foo")
    end
  end

  defmodule DummyRouter do
    use Phoenix.Router
    use Terraform, terraformer: DummyTerraformer

    get "/foo", FooController, :index
  end

  test "forwards requests if not defined on router" do
    conn = call(DummyRouter, conn(:get, "bar"))
    assert conn.status == 200
    assert conn.resp_body == "bar"
  end

  test "gets handled in the default handler" do
    conn = call(DummyRouter, conn(:get, "foo"))
    assert conn.status == 200
    assert conn.resp_body == "foo"
  end

  defp call(mod, conn) do
    mod.call(conn, [])
  end
end
