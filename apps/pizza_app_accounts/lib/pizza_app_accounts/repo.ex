defmodule PizzaAppAccounts.Repo do
  use Ecto.Repo,
    otp_app: :pizza_app_accounts,
    adapter: Ecto.Adapters.Postgres
end
