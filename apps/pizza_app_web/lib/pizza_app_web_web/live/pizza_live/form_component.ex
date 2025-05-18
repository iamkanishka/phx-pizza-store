defmodule PizzaAppWeb.PizzaLive.FormComponent do
  use PizzaAppWeb, :live_component

  alias PizzaAppWeb.Customer

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage pizza records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="pizza-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:price]} type="number" label="Price" step="any" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Pizza</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{pizza: pizza} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Customer.change_pizza(pizza))
     end)}
  end

  @impl true
  def handle_event("validate", %{"pizza" => pizza_params}, socket) do
    changeset = Customer.change_pizza(socket.assigns.pizza, pizza_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pizza" => pizza_params}, socket) do
    save_pizza(socket, socket.assigns.action, pizza_params)
  end

  defp save_pizza(socket, :edit, pizza_params) do
    case Customer.update_pizza(socket.assigns.pizza, pizza_params) do
      {:ok, pizza} ->
        notify_parent({:saved, pizza})

        {:noreply,
         socket
         |> put_flash(:info, "Pizza updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pizza(socket, :new, pizza_params) do
    case Customer.create_pizza(pizza_params) do
      {:ok, pizza} ->
        notify_parent({:saved, pizza})

        {:noreply,
         socket
         |> put_flash(:info, "Pizza created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
