defmodule MaintenanceModeTest do
  use ExUnit.Case

  alias MaintenanceMode.StatusAgent

  describe "config/0 when used" do
    test "get config" do
      opts = Application.get_env(:maintenance_mode, MyMaintenanceMode, [])

      assert MyMaintenanceMode.config() == []
    end
  end

  describe "disable/0 when used" do
    test "disable maintenance mode" do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => true}})

      assert MyMaintenanceMode.disable() == :ok
      assert MyMaintenanceMode.disabled?() == true
    end
  end

  describe "disabled?/0 when used" do
    test "true when disabled" do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => false}})

      assert MyMaintenanceMode.disabled?() == true
    end

    test "false when enabled" do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => true}})

      assert MyMaintenanceMode.disabled?() == false
    end
  end

  describe "enable/0 when used" do
    test "enable maintenance mode" do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => false}})

      assert MyMaintenanceMode.enable() == :ok
      assert MyMaintenanceMode.enabled?() == true
    end
  end

  describe "enabled?/0 when used" do
    test "true when enabled" do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => true}})

      assert MyMaintenanceMode.enabled?() == true
    end

    test "false when disabled" do
      start_supervised!({StatusAgent, entries: %{MyMaintenanceMode => false}})

      assert MyMaintenanceMode.enabled?() == false
    end
  end
end
