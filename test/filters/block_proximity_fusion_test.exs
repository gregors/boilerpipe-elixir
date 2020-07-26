defmodule Boilerpipe.Filters.BlockProximityFusionTest do
  use ExUnit.Case

  alias Boilerpipe.Document.TextBlock
  alias Boilerpipe.Filters.BlockProximityFusion

  test "process/2 where blocks exceed distance nothing changes" do
    text_block1 = TextBlock.new('one',   0)
    text_block2 = TextBlock.new('two',   1)
    text_block3 = TextBlock.new('three', 2)
    text_block4 = TextBlock.new('four',  3)
    text_blocks = [text_block1, text_block2, text_block3, text_block4]

    pf = BlockProximityFusion.new(1, true, false)

    assert %{text_blocks: [_, _, _, _]} = BlockProximityFusion.process(pf, %{text_blocks: text_blocks})
  end
end
