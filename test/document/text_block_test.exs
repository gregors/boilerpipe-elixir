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

  test "is_content?  returns true if content" do
    tb = %TextBlock{}
    assert tb.content == false
    assert TextBlock.is_content?(tb) == false

    tb = %TextBlock{ tb | content: true }
    assert tb.content == true
    assert TextBlock.is_content?(tb) == true
  end

  test "is_not_content?  returns true if not content" do
    tb = %TextBlock{}
    assert tb.content == false
    assert TextBlock.is_not_content?(tb) == true

    tb = %TextBlock{ tb | content: true }
    assert tb.content == true
    assert TextBlock.is_not_content?(tb) == false
  end
end
