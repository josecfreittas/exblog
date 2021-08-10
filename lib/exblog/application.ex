defmodule Exblog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Exblog.Repo,
      # Start the Telemetry supervisor
      ExblogWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Exblog.PubSub},
      # Start the Endpoint (http/https)
      ExblogWeb.Endpoint
      # Start a worker by calling: Exblog.Worker.start_link(arg)
      # {Exblog.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exblog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExblogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
