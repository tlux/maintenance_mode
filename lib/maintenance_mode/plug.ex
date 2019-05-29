defmodule MaintenanceMode.Plug do
  @moduledoc """
  A middleware that returns a 503 status when the maintenance mode is enabled
  for the particular application.   
  """

  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(opts) do
    mod = Keyword.fetch!(opts, :mod)
    {mod, mod.config()}
  end

  @impl true
  def call(conn, {mod, opts}) do
    if mod.enabled?() do
      send_maintenance_resp(conn, opts)
    else
      conn
    end
  end

  defp send_maintenance_resp(conn, _opts) do
    conn
    |> send_resp(503, "Maintenance mode active")
    |> halt()
  end
end
