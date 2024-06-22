defmodule VemoslaWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VemoslaWeb.Telemetry,
      # Start a worker by calling: VemoslaWeb.Worker.start_link(arg)
      # {VemoslaWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      VemoslaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VemoslaWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VemoslaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
