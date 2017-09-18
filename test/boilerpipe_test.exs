defmodule BoilerpipeTest do
  use ExUnit.Case
  doctest Boilerpipe

  test "greets the world" do
    assert Boilerpipe.hello() == :world
  end
end
