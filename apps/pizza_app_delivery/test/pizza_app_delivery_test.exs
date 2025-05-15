defmodule PizzaAppDeliveryTest do
  use ExUnit.Case
  doctest PizzaAppDelivery

  test "greets the world" do
    assert PizzaAppDelivery.hello() == :world
  end
end
