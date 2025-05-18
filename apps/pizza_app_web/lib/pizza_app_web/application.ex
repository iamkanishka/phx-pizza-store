defmodule PizzaAppWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PizzaAppWebWeb.Telemetry,
      PizzaAppWeb.Repo,
      PizzaAppOrdering.Repo,
      PizzaAppAccounts.Repo,
      {DNSCluster, query: Application.get_env(:pizza_app_web, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PizzaAppWeb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PizzaAppWeb.Finch},
      # Start a worker by calling: PizzaAppWeb.Worker.start_link(arg)
      # {PizzaAppWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      PizzaAppWebWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PizzaAppWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PizzaAppWebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
