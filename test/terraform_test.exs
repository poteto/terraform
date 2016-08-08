defmodule TerraformTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest Terraform

  defmodule DummyTerraformer do
    import Plug.Conn

    def get(path, conn) do
      require IEx
      IEx.pry
      send_resp(conn, 200, path)
    end
  end

  defmodule DummyRouter do
    use Plug.Router
    use Plug.ErrorHandler
    use Terraform.Discovery,
      terraformer: DummyTerraformer

    plug :dummy

    get "/foo" do
      send_resp(conn, 200, "foo")
    end

    def dummy(conn, _), do: conn
  end

  test "forwards requests if not defined on router" do
    conn = call(DummyRouter, conn(:get, "bar"))
    require IEx
    IEx.pry
  end

  defp call(mod, conn) do
    mod.call(conn, [])
  end
end
