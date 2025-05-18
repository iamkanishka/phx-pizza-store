defmodule PizzaAppWeb.PizzaLive.Index do
  use PizzaAppWeb, :live_view

  alias PizzaAppWeb.Customer
  alias PizzaAppWeb.Customer.Pizza

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :pizzas, Customer.list_pizzas())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pizza")
    |> assign(:pizza, Customer.get_pizza!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pizza")
    |> assign(:pizza, %Pizza{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pizzas")
    |> assign(:pizza, nil)
  end

  @impl true
  def handle_info({PizzaAppWeb.PizzaLive.FormComponent, {:saved, pizza}}, socket) do
    {:noreply, stream_insert(socket, :pizzas, pizza)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pizza = Customer.get_pizza!(id)
    {:ok, _} = Customer.delete_pizza(pizza)

    {:noreply, stream_delete(socket, :pizzas, pizza)}
  end
end
