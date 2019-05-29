defmodule MaintenanceMode.StatusAgentTest do
  use ExUnit.Case

  alias MaintenanceMode.StatusAgent

  setup do
    Temp.track!()
    {:ok, opts: [path: Temp.mkdir!()]}
  end

  describe "enable/2" do
    setup do
      start_supervised!({StatusAgent, entries: %{TestModule => false}})
      :ok
    end

    test "set maintenance mode enabled for given module", %{opts: opts} do
      assert :ok = StatusAgent.enable(TestModule, opts)
      assert StatusAgent.enabled?(TestModule, opts)
    end

    test "do not set maintenance mode enabled for other module", %{opts: opts} do
      assert :ok = StatusAgent.enable(TestModule, opts)
      refute StatusAgent.enabled?(OtherTestModule, opts)
    end

    # TODO: Test file creation
  end

  describe "disable/2" do
    setup do
      start_supervised!({StatusAgent, entries: %{TestModule => true}})
      :ok
    end

    test "set maintenance mode disabled for given module", %{opts: opts} do
      assert :ok = StatusAgent.disable(TestModule, opts)
      assert StatusAgent.disabled?(TestModule, opts)
    end

    test "maintenance mode disabled by default for unknown module", %{
      opts: opts
    } do
      assert :ok = StatusAgent.disable(TestModule, opts)
      assert StatusAgent.disabled?(OtherTestModule, opts)
    end

    # TODO: Test file deletion
  end

  describe "enabled?/2" do
    test "true when module known and mode enabled", %{opts: opts} do
      start_supervised!({StatusAgent, entries: %{TestModule => true}})

      assert StatusAgent.enabled?(TestModule, opts) == true
    end

    test "false when module known and mode disabled", %{opts: opts} do
      start_supervised!({StatusAgent, entries: %{TestModule => false}})

      assert StatusAgent.enabled?(TestModule, opts) == false
    end

    test "false when module unknown", %{opts: opts} do
      start_supervised!(StatusAgent)

      assert StatusAgent.enabled?(OtherTestModule, opts) == false
    end
  end

  describe "disabled?/2" do
    test "true when module known and mode disabled", %{opts: opts} do
      start_supervised!({StatusAgent, entries: %{TestModule => false}})

      assert StatusAgent.disabled?(TestModule, opts) == true
    end

    test "false when module known and mode enabled", %{opts: opts} do
      start_supervised!({StatusAgent, entries: %{TestModule => true}})

      assert StatusAgent.disabled?(TestModule, opts) == false
    end

    test "false when module unknown", %{opts: opts} do
      start_supervised!(StatusAgent)

      assert StatusAgent.disabled?(OtherTestModule, opts) == true
    end
  end

  describe "refresh_all/0" do
    test "clear state", %{opts: opts} do
      start_supervised!(
        {StatusAgent, entries: %{TestModule => true, OtherTestModule => false}}
      )

      assert StatusAgent.enabled?(TestModule, opts)
      assert StatusAgent.disabled?(OtherTestModule, opts)

      assert :ok = StatusAgent.refresh_all()

      assert StatusAgent.disabled?(TestModule, opts)
      assert StatusAgent.disabled?(OtherTestModule, opts)
    end
  end
end
