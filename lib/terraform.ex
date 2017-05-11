defmodule Terraform do
  @moduledoc """
  A simple plug designed to work with Phoenix. Terraform allows you to incrementally transform an older API into one powered by Phoenix - one endpoint at a time.

  ## Usage

  First, add to your router:

      defmodule MyApp.Router do
        use Terraform, terraformer: MyApp.Terraformers.Foo

        # ...
      end

  Then, define a new `Terraformer`, which uses `Plug.Router`. Any request that goes to a route that isn't defined on your Phoenix app will hit this plug, and you can then handle it using a familiar DSL:

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
  """

  defmacro __using__(opts) do
    quote location: :keep do
      Module.register_attribute __MODULE__, :terraformer, []
      @terraformer Keyword.get(unquote(opts), :terraformer)
      @before_compile Terraform
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote location: :keep do
      defoverridable [call: 2]

      def call(conn, opts) do
        super(conn, opts)
      catch
        _, %Phoenix.Router.NoRouteError{conn: conn} ->
          terraform(conn, @terraformer)
      end

      def terraform(%Plug.Conn{} = conn, terraformer) do
        terraformer.call(conn, [])
      end

      defoverridable [terraform: 2]
    end
  end
end
