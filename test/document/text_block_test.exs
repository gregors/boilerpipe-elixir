defmodule DocumentTextBlockTest do
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

    tb = %TextBlock{tb | content: true}
    assert tb.content == true
    assert TextBlock.is_content?(tb) == true
  end

  test "is_not_content?  returns true if not content" do
    tb = %TextBlock{}
    assert tb.content == false
    assert TextBlock.is_not_content?(tb) == true

    tb = %TextBlock{tb | content: true}
    assert tb.content == true
    assert TextBlock.is_not_content?(tb) == false
  end

  test "add_label adds a label" do
    tb = %TextBlock{}
    assert Enum.count(tb.labels) == 0

    tb = TextBlock.add_label(tb, :TITLE)
    assert Enum.count(tb.labels) == 1
  end

  test "merge/2 merges TextBlocks" do
    block = TextBlock.new("hello")
    another_block = TextBlock.new("good-bye")
    block = TextBlock.merge(block, another_block)
    assert block.text == "hello\ngood-bye"
  end
end
