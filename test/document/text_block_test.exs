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
    block = %TextBlock{TextBlock.new("hello") | num_words: 1}
    another_block = TextBlock.new("good-bye")
    block = TextBlock.merge(block, another_block)
    assert block.text == "hello\ngood-bye"
  end

  test "merge/2 adds num_words" do
    block = %TextBlock{text: "hello", num_words: 1}
    another_block = %TextBlock{text: "good-bye", num_words: 1}
    block = TextBlock.merge(block, another_block)
    assert block.num_words == 2
  end

  test "merge/2 adds num_words_in_anchor_text" do
    block = %TextBlock{text: "hello", num_words_in_anchor_text: 1}
    another_block = %TextBlock{text: "good-bye", num_words_in_anchor_text: 1}
    block = TextBlock.merge(block, another_block)
    assert block.num_words_in_anchor_text == 2
  end

  test "merge/2 adds num_words_in_wrapped_lines" do
    block = %TextBlock{text: "hello", num_words_in_wrapped_lines: 1}
    another_block = %TextBlock{text: "good-bye", num_words_in_wrapped_lines: 1}
    block = TextBlock.merge(block, another_block)
    assert block.num_words_in_wrapped_lines == 2
  end

  test "merge/2 adds num_wrapped_lines" do
    block = %TextBlock{}
    another_block = %TextBlock{}
    block = TextBlock.merge(block, another_block)
    assert block.num_wrapped_lines == 2
  end

  test "merge/2 set the starting block index to the min of the two" do
    block = %TextBlock{offset_blocks_start: 5}
    another_block = %TextBlock{offset_blocks_start: 3}
    block = TextBlock.merge(block, another_block)
    assert block.offset_blocks_start == 3
  end

  test "merge/2 set the offset_block_end uses the later end" do
    block = %TextBlock{offset_blocks_end: 5}
    another_block = %TextBlock{offset_blocks_end: 3}
    block = TextBlock.merge(block, another_block)
    assert block.offset_blocks_end == 5
  end

  test 'merge/2 recomputes densities' do
    block = %TextBlock{
      text: "one",
      num_words: 10,
      num_words_in_anchor_text: 5,
      num_words_in_wrapped_lines: 10,
      num_wrapped_lines: 2
    }

    another_block = %TextBlock{
      text: "two",
      num_words: 10,
      num_words_in_anchor_text: 5,
      num_words_in_wrapped_lines: 10,
      num_wrapped_lines: 3
    }

    block = TextBlock.merge(block, another_block)

    assert block.text_density == 4.0
    assert block.link_density == 0.5
  end

  test "merge/2 if one block is content the merged block is content" do
    b1 = %TextBlock{}
    assert b1.content == false

    b2 = %TextBlock{b1 | content: true}
    assert b2.content == true

    block = TextBlock.merge(b1, b2)
    assert block.content == true
  end
end
