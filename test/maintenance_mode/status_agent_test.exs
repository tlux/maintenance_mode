defmodule MaintenanceMode.StatusAgentTest do
  use ExUnit.Case

  alias MaintenanceMode.StatusAgent

  describe "enable/1" do
    test "set maintenance mode enabled for given module" do
      assert :ok = MaintenanceMode.enable(TestModule)
      assert MaintenanceMode.enabled?(TestModule)
    end

    test "do not set maintenance mode enabled for other module" do
      assert :ok = MaintenanceMode.enable(TestModule)
      refute MaintenanceMode.enabled?(OtherTestModule)
    end
  end

  describe "disable/1" do
    setup do
      :ok = MaintenanceMode.enable(TestModule)
    end

    test "set maintenance mode disabled for given module" do
      assert :ok = MaintenanceMode.disable(TestModule)
      assert MaintenanceMode.disabled?(TestModule)
    end

    test "do not set maintenance mode disabled for other module" do
      assert :ok = MaintenanceMode.disable(TestModule)
      refute MaintenanceMode.disabled?(OtherTestModule)
    end
  end
end
