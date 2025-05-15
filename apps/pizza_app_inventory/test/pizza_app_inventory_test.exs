defmodule PizzaAppInventoryTest do
  use ExUnit.Case
  doctest PizzaAppInventory

  test "greets the world" do
    assert PizzaAppInventory.hello() == :world
  end
end
