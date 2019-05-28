defmodule MaintenanceMode.MixProject do
  use Mix.Project

  def project do
    [
      app: :maintenance_mode,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [],
      mod: {MaintenanceMode.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:excoveralls, "~> 0.11.0", only: :test},
      {:plug, "~> 1.8.0"},
      {:temp, "~> 0.4", only: :test}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
