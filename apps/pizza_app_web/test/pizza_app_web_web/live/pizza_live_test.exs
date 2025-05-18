defmodule PizzaAppWeb.PizzaLiveTest do
  use PizzaAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import PizzaAppWeb.CustomerFixtures

  @create_attrs %{name: "some name", description: "some description", price: "120.5"}
  @update_attrs %{name: "some updated name", description: "some updated description", price: "456.7"}
  @invalid_attrs %{name: nil, description: nil, price: nil}

  defp create_pizza(_) do
    pizza = pizza_fixture()
    %{pizza: pizza}
  end

  describe "Index" do
    setup [:create_pizza]

    test "lists all pizzas", %{conn: conn, pizza: pizza} do
      {:ok, _index_live, html} = live(conn, ~p"/pizzas")

      assert html =~ "Listing Pizzas"
      assert html =~ pizza.name
    end

    test "saves new pizza", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pizzas")

      assert index_live |> element("a", "New Pizza") |> render_click() =~
               "New Pizza"

      assert_patch(index_live, ~p"/pizzas/new")

      assert index_live
             |> form("#pizza-form", pizza: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pizza-form", pizza: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pizzas")

      html = render(index_live)
      assert html =~ "Pizza created successfully"
      assert html =~ "some name"
    end

    test "updates pizza in listing", %{conn: conn, pizza: pizza} do
      {:ok, index_live, _html} = live(conn, ~p"/pizzas")

      assert index_live |> element("#pizzas-#{pizza.id} a", "Edit") |> render_click() =~
               "Edit Pizza"

      assert_patch(index_live, ~p"/pizzas/#{pizza}/edit")

      assert index_live
             |> form("#pizza-form", pizza: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pizza-form", pizza: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pizzas")

      html = render(index_live)
      assert html =~ "Pizza updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes pizza in listing", %{conn: conn, pizza: pizza} do
      {:ok, index_live, _html} = live(conn, ~p"/pizzas")

      assert index_live |> element("#pizzas-#{pizza.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pizzas-#{pizza.id}")
    end
  end

  describe "Show" do
    setup [:create_pizza]

    test "displays pizza", %{conn: conn, pizza: pizza} do
      {:ok, _show_live, html} = live(conn, ~p"/pizzas/#{pizza}")

      assert html =~ "Show Pizza"
      assert html =~ pizza.name
    end

    test "updates pizza within modal", %{conn: conn, pizza: pizza} do
      {:ok, show_live, _html} = live(conn, ~p"/pizzas/#{pizza}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pizza"

      assert_patch(show_live, ~p"/pizzas/#{pizza}/show/edit")

      assert show_live
             |> form("#pizza-form", pizza: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#pizza-form", pizza: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/pizzas/#{pizza}")

      html = render(show_live)
      assert html =~ "Pizza updated successfully"
      assert html =~ "some updated name"
    end
  end
end
