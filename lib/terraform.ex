defmodule Terraform do
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
        try do
          super(conn, opts)
        catch
          _, %Phoenix.Router.NoRouteError{conn: conn} -> terraform(conn, @terraformer)
        end
      end

      defp terraform(conn, terraformer) do
        terraformer.call(conn, [])
      end

      defoverridable [terraform: 2]
    end
  end
end
