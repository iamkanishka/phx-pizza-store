defmodule PizzaAppOrdering.Repo do
  use Ecto.Repo,
    otp_app: :pizza_app_ordering,
    adapter: Ecto.Adapters.Postgres
end
