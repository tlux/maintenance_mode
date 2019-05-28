defmodule MaintenanceMode.StatusAgentTest do
  use ExUnit.Case

  alias MaintenanceMode.StatusAgent

  describe "enable/1" do
    setup do
      start_supervised!({StatusAgent, entries: %{TestModule => false}})
      :ok
    end

    test "set maintenance mode enabled for given module" do
      assert :ok = StatusAgent.enable(TestModule)
      assert StatusAgent.enabled?(TestModule)
    end

    test "do not set maintenance mode enabled for other module" do
      assert :ok = StatusAgent.enable(TestModule)
      refute StatusAgent.enabled?(OtherTestModule)
    end

    # TODO: Test file creation
  end

  describe "disable/1" do
    setup do
      start_supervised!({StatusAgent, entries: %{TestModule => true}})
      :ok
    end

    test "set maintenance mode disabled for given module" do
      assert :ok = StatusAgent.disable(TestModule)
      assert StatusAgent.disabled?(TestModule)
    end

    test "maintenance mode disabled by default for unknown module" do
      assert :ok = StatusAgent.disable(TestModule)
      assert StatusAgent.disabled?(OtherTestModule)
    end

    # TODO: Test file deletion
  end

  describe "enabled?/1" do
    test "true when module known and mode enabled" do
      start_supervised!({StatusAgent, entries: %{TestModule => true}})

      assert StatusAgent.enabled?(TestModule) == true
    end

    test "false when module known and mode disabled" do
      start_supervised!({StatusAgent, entries: %{TestModule => false}})

      assert StatusAgent.enabled?(TestModule) == false
    end

    test "false when module unknown" do
      start_supervised!(StatusAgent)

      assert StatusAgent.enabled?(OtherTestModule) == false
    end
  end

  describe "disabled?/1" do
    test "true when module known and mode disabled" do
      start_supervised!({StatusAgent, entries: %{TestModule => false}})

      assert StatusAgent.disabled?(TestModule) == true
    end

    test "false when module known and mode enabled" do
      start_supervised!({StatusAgent, entries: %{TestModule => true}})

      assert StatusAgent.disabled?(TestModule) == false
    end

    test "false when module unknown" do
      start_supervised!(StatusAgent)

      assert StatusAgent.disabled?(OtherTestModule) == true
    end
  end
end
