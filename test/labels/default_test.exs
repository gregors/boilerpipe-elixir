defmodule LabelsDefaultTest do
  use ExUnit.Case
  alias Boilerpipe.Labels.Default

  test "has markup prefix" do
    assert Default.markup_prefix() == "<"
  end
end
