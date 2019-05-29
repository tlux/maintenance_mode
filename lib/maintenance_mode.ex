defmodule MaintenanceMode do
  alias MaintenanceMode.StatusAgent

  @callback config() :: Keyword.t()
  @callback disable() :: :ok
  @callback disabled?() :: boolean
  @callback enable() :: :ok
  @callback enabled?() :: boolean

  @doc false
  defmacro __using__(otp_app: otp_app) do
    quote do
      @behaviour unquote(__MODULE__)

      @config Application.get_env(unquote(otp_app), __MODULE__, [])

      @impl true
      def config, do: @config

      @impl true
      def disable do
        StatusAgent.disable(__MODULE__, @config)
      end

      @impl true
      def disabled? do
        StatusAgent.disabled?(__MODULE__, @config)
      end

      @impl true
      def enable do
        StatusAgent.enable(__MODULE__, @config)
      end

      @impl true
      def enabled? do
        StatusAgent.enabled?(__MODULE__, @config)
      end
    end
  end
end
