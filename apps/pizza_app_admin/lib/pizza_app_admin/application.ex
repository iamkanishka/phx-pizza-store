defmodule PizzaAppAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PizzaAppAdminWeb.Telemetry,
      PizzaAppAdmin.Repo,
      {DNSCluster, query: Application.get_env(:pizza_app_admin, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PizzaAppAdmin.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PizzaAppAdmin.Finch},
      # Start a worker by calling: PizzaAppAdmin.Worker.start_link(arg)
      # {PizzaAppAdmin.Worker, arg},
      # Start to serve requests, typically the last entry
      PizzaAppAdminWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PizzaAppAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PizzaAppAdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
