defmodule MaintenanceMode.PlugTest do
  use ExUnit.Case

  alias MaintenanceMode.Plug, as: MaintenanceModePlug
  alias MaintenanceMode.StatusAgent
  alias Plug.Adapters.Test.Conn, as: TestConn
  alias Plug.Conn

  describe "init/1" do
    test "get config when mod option given" do
      assert MaintenanceModePlug.init(mod: MyMaintenanceMode) ==
               {MyMaintenanceMode, []}
    end

    test "raise when mod option missing" do
      assert_raise KeyError, ~r/key :mod not found/, fn ->
        MaintenanceModePlug.init([])
      end
    end
  end

  describe "call/2" do
    setup do
      {:ok, conn: build_conn()}
    end

    test "do not update conn when maintenance mode disabled", context do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => false}})

      assert MaintenanceModePlug.call(context.conn, {MyMaintenanceMode, []}) ==
               context.conn
    end

    test "send 503 when maintenance mode enabled", context do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => true}})

      conn = MaintenanceModePlug.call(context.conn, {MyMaintenanceMode, []})

      assert conn.status == 503
      assert conn.halted
    end
  end

  defp build_conn do
    TestConn.conn(%Conn{}, :get, "/test", %{})
  end
end
