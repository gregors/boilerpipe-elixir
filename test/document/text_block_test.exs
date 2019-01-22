defmodule DocumentTextBockTest do
  use ExUnit.Case
  alias Boilerpipe.Document.TextBlock

  test "text outputs text" do
    assert %TextBlock{}.text == "" 
  end

  test "set_tag_level sets the tag level" do
    tb = %TextBlock{}
    assert tb.tag_level == 0 

    tb = TextBlock.set_tag_level(tb, 1)
    assert tb.tag_level == 1 
  end
end
