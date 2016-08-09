defmodule TerraformTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest Terraform

  defmodule DummyTerraformer do
    import Plug.Conn

    def init(opts), do: opts

    def call(%{method: "GET", request_path: "/bar"} = conn, _) do
      require IEx
      IEx.pry
      send_resp(conn, 200, "bar")
    end

    def call(conn, _) do
      require IEx
      IEx.pry
      send_resp(conn, 201, "bar")
    end
  end

  defmodule DummyRouter do
    use Plug.Router
    use Plug.ErrorHandler

    plug :dummy
    plug :match
    plug :dispatch

    use Terraform.Discovery,
      terraformer: DummyTerraformer

    get "/foo" do
      send_resp(conn, 200, "foo")
    end

    def dummy(conn, _), do: conn
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
