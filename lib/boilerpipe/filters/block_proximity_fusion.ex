defmodule Boilerpipe.Filters.BlockProximityFusion do
  alias Boilerpipe.Filters.BlockProximityFusion
  alias Boilerpipe.Document.TextDocument

  defstruct max_blocks_distance: 0, content_only: false, same_tag_level_only: false

  def new(max_blocks_distance, content_only, same_tag_level_only) do
    %BlockProximityFusion{
      max_blocks_distance: max_blocks_distance,
      content_only: content_only,
      same_tag_level_only: same_tag_level_only
    }
  end

  def process(%{}, %{text_blocks: text_blocks}) when length(text_blocks) < 2, do: false

  def process(%BlockProximityFusion{} = pf, %{text_blocks: text_blocks} = doc) do
    new_blocks = merge(pf, text_blocks, [])
    TextDocument.replace_text_blocks(doc, new_blocks)
  end

  def merge(_pf, [first | []], acc), do: [first | acc] |> Enum.reverse()

  def merge(pf, [first, second | tail], acc) when is_list(acc) do
    diff_blocks = second.offset_blocks_start - first.offset_blocks_end - 1

    with true <- diff_blocks <= pf.max_blocks_distance,
         false <- (!first.content || !second.content) && pf.content_only,
         false <- first.tag_level != second.tag_level && pf.same_tag_level_only do
      new_block = TextBlock.merge(first, second)
      merge(pf, [new_block | tail], acc)
    else
      _ ->
        merge(pf, [second | tail], [first | acc])
    end
  end
end
