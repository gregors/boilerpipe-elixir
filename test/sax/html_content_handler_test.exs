defmodule Boilerpipe.SAX.HtmlContentHandlerTest do
  use ExUnit.Case

  test "new/0 creates initial state" do
    state = Boilerpipe.SAX.HtmlContentHandler.new()
    assert %{} = state
  end
end
