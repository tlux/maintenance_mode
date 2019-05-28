defmodule MaintenanceMode.StatusAgent do
  use Agent

  @doc """
  Starts the status agent.

  ## Options

  * `:entries` - The map to initialize the agent with.

  Other options are forwarded to `Agent.start_link/4`.
  """
  @spec start_link(Keyword.t()) :: Agent.on_start()
  def start_link(opts \\ []) do
    {state, agent_opts} = Keyword.pop(opts, :entries, %{})
    agent_opts = Keyword.put(agent_opts, :name, __MODULE__)
    Agent.start_link(__MODULE__, :init_state, [state], agent_opts)
  end

  @doc """
  Disables the maintenance mode using the given config.
  """
  @spec disable(module, Keyword.t()) :: :ok
  def disable(mod, opts) do
    Agent.update(__MODULE__, __MODULE__, :disable_maintenance, [mod, opts])
  end

  @doc """
  Determines whether the maintenance mode is disabled.
  """
  @spec disabled?(module, Keyword.t()) :: boolean
  def disabled?(mod, opts) do
    !enabled?(mod, opts)
  end

  @doc """
  Enables the maintenance mode using the given config.
  """
  @spec enable(module, Keyword.t()) :: :ok
  def enable(mod, opts) do
    Agent.update(__MODULE__, __MODULE__, :enable_maintenance, [mod, opts])
  end

  @doc """
  Determines whether the maintenance mode is enabled.
  """
  @spec enabled?(module, Keyword.t()) :: boolean
  def enabled?(mod, opts) do
    Agent.get_and_update(__MODULE__, __MODULE__, :maintenance_enabled?, [
      mod,
      opts
    ])
  end

  @doc """
  Resets the state of the agent which is required when the maintenance file is
  removed from the file system.
  """
  @spec refresh_all() :: :ok
  def refresh_all do
    Agent.update(__MODULE__, __MODULE__, :clear_state, [])
  end

  @doc false
  def init_state(state), do: state

  @doc false
  def clear_state(_state), do: %{}

  @doc false
  def maintenance_enabled?(state, mod, opts) do
    Map.get_and_update(state, mod, fn
      nil ->
        enabled? = File.exists?(indicator_file(mod, opts))
        {enabled?, enabled?}

      enabled? ->
        {enabled?, enabled?}
    end)
  end

  @doc false
  def enable_maintenance(state, mod, opts) do
    path = indicator_file(mod, opts)
    path |> Path.dirname() |> File.mkdir_p()
    File.touch(path)
    Map.put(state, mod, true)
  end

  @doc false
  def disable_maintenance(state, mod, opts) do
    File.rm(indicator_file(mod, opts))
    Map.put(state, mod, false)
  end

  defp indicator_file(mod, _opts) do
    ["priv", ".maintenance_mode", Macro.underscore(mod)]
    |> Path.join()
    |> Path.expand()
  end
end
