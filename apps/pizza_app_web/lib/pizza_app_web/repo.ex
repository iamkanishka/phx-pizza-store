defmodule PizzaAppWeb.Repo do
  use Ecto.Repo,
    otp_app: :pizza_app_web,
    adapter: Ecto.Adapters.Postgres
end
