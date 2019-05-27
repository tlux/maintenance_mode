defmodule MaintenanceMode.StatusAgent do
  use Agent

  @doc """
  Starts the status agent.
  """
  @spec start_link(Keyword.t()) :: Agent.on_start()
  def start_link(_opts) do
    Agent.start_link(__MODULE__, :reset_state, [], name: __MODULE__)
  end

  @doc """
  Determines whether the maintenance mode is disabled.
  """
  @spec disabled?(module) :: boolean
  def disabled?(mod), do: !enabled?(mod)

  @doc """
  Determines whether the maintenance mode is enabled.
  """
  @spec enabled?(module) :: boolean
  def enabled?(mod) do
    Agent.get_and_update(__MODULE__, __MODULE__, :maintenance_enabled?, [mod])
  end

  @spec enable(module) :: :ok
  def enable(mod) do
    Agent.update(__MODULE__, __MODULE__, :enable_maintenance, [mod])
  end

  @spec disable(module) :: :ok
  def disable(mod) do
    Agent.update(__MODULE__, __MODULE__, :disable_maintenance, [mod])
  end

  @doc """
  Resets the state of the agent which is required when the maintenance file is
  removed from the file system.
  """
  @spec reset() :: :ok
  def reset do
    Agent.update(__MODULE__, __MODULE__, :reset_state, [])
  end

  @doc false
  def reset_state(_state \\ nil), do: %{}

  @doc false
  def maintenance_enabled?(state, mod) do
    Map.get_and_update(state, mod, fn
      nil ->
        enabled? = File.exists?(indicator_file(mod))
        {enabled?, enabled?}

      enabled? ->
        {enabled?, enabled?}
    end)
  end

  @doc false
  def enable_maintenance(state, mod) do
    path = indicator_file(mod)
    path |> Path.dirname() |> File.mkdir_p()
    File.touch(path)
    Map.put(state, mod, true)
  end

  @doc false
  def disable_maintenance(state, mod) do
    File.rm(indicator_file(mod))
    Map.put(state, mod, false)
  end

  defp indicator_file(mod) do
    ["priv", ".maintenance_#{Macro.underscore(mod)}"]
    |> Path.join()
    |> Path.expand()
  end
end
