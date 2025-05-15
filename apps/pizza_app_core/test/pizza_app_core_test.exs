defmodule PizzaAppCoreTest do
  use ExUnit.Case
  doctest PizzaAppCore

  test "greets the world" do
    assert PizzaAppCore.hello() == :world
  end
end
