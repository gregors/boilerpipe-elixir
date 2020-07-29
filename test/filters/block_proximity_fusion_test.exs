defmodule Boilerpipe.Filters.BlockProximityFusionTest do
  use ExUnit.Case

  alias Boilerpipe.Document.TextBlock
  alias Boilerpipe.Filters.BlockProximityFusion

  def get_text_blocks() do
    text_block1 = TextBlock.new("one", 0)
    text_block2 = TextBlock.new("two", 1)
    text_block3 = TextBlock.new("three", 2)
    text_block4 = TextBlock.new("four", 3)
    [text_block1, text_block2, text_block3, text_block4]
  end

  def block_settings(blocks) do
    [a, b, c, d] = blocks

    [
      %{a | content: true},
      %{b | content: false},
      %{c | content: false},
      %{d | content: true}
    ]
  end

  # only_content: true, same_tag_level: false
  test "process/2 where blocks exceed distance nothing changes" do
    text_blocks = get_text_blocks() |> block_settings()
    filter = BlockProximityFusion.new(1, true, false)

    doc = BlockProximityFusion.process(filter, %{text_blocks: text_blocks})
    assert %{text_blocks: text_blocks} = doc
  end

  # only_content: false, same_tag_level: false
  test "process/2 where blocks do not exceed distance it fuses adjacent blocks" do
    text_blocks = get_text_blocks() |> block_settings()
    last_tb = text_blocks |> List.last()
    assert last_tb.text == "four"

    filter = BlockProximityFusion.new(1, false, false)
    doc = BlockProximityFusion.process(filter, %{text_blocks: text_blocks})

    last_tb = doc.text_blocks |> List.last()
    assert last_tb.text == "three\nfour"
  end

  test "process/2 where blocks do not exceed distance it removes one of the blocks from the Text Document" do
    text_blocks = get_text_blocks() |> block_settings()
    assert length(text_blocks) == 4

    filter = BlockProximityFusion.new(1, false, false)
    doc = BlockProximityFusion.process(filter, %{text_blocks: text_blocks})

    assert length(doc.text_blocks) == 3
  end
end
