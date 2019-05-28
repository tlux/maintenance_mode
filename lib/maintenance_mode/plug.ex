defmodule MaintenanceMode.Plug do
  @behaviour Plug

  import Plug.Conn

  alias MaintenanceMode.StatusAgent

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, opts) do
    if StatusAgent.enabled?(opts[:mod]) do
      send_maintenance_resp(conn)
    else
      conn
    end
  end

  defp send_maintenance_resp(conn) do
    conn
    |> send_resp(503, "Maintenance mode active")
    |> halt()
  end
end
