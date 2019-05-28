defmodule MaintenanceMode do
  alias MaintenanceMode.StatusAgent

  defdelegate disable(mod), to: StatusAgent
  defdelegate disabled?(mod), to: StatusAgent
  defdelegate enable(mod), to: StatusAgent
  defdelegate enabled?(mod), to: StatusAgent

  @callback config() :: Keyword.t()
  @callback disable() :: :ok
  @callback disabled?() :: boolean
  @callback enable() :: :ok
  @callback enabled?() :: boolean

  @spec __using__(Keyword.t()) :: Macro.t()
  defmacro __using__(otp_app: otp_app) do
    quote bind_quoted: [otp_app: otp_app] do
      @behaviour unquote(__MODULE__)

      @impl true
      def config do
        Application.get_env(unquote(otp_app), __MODULE__, [])
      end

      @impl true
      def disable, do: MaintenanceMode.disable(__MODULE__)

      @impl true
      def disabled?, do: MaintenanceMode.disabled?(__MODULE__)

      @impl true
      def enable, do: MaintenanceMode.enable(__MODULE__)

      @impl true
      def enabled?, do: MaintenanceMode.enabled?(__MODULE__)
    end
  end
end
