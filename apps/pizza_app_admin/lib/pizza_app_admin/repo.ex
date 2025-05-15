defmodule PizzaAppAdmin.Repo do
  use Ecto.Repo,
    otp_app: :pizza_app_admin,
    adapter: Ecto.Adapters.Postgres
end
