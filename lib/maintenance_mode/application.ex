defmodule MaintenanceMode.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias MaintenanceMode.StatusAgent

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {StatusAgent, name: StatusAgent}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MaintenanceMode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
