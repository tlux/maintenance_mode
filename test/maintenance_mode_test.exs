defmodule MaintenanceModeTest do
  use ExUnit.Case
  doctest MaintenanceMode

  test "greets the world" do
    assert MaintenanceMode.hello() == :world
  end
end
