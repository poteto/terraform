defmodule Terraform.Discovery do
  defmacro __using__(opts) do
    quote location: :keep do
      Module.register_attribute __MODULE__, :terraformer, []
      @terraformer Keyword.get(unquote(opts), :terraformer)
      @before_compile Terraform.Discovery
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote location: :keep do
      defoverridable [call: 2]
      require Logger

      def call(conn, opts) do
        try do
          super(conn, opts)
        catch
          _, %{conn: conn} -> terraform(conn, @terraformer)
        end
      end

      defp terraform(conn, terraformer) do
        apply(terraformer, :call, [conn, []])
      end

      defoverridable [terraform: 2]
    end
  end
end
