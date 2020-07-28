defmodule Boilerpipe.Filters.SimpleBlockFusionProcessor do
  alias Boilerpipe.Document.{TextBlock, TextDocument}

  def process(%{text_blocks: text_blocks} = doc) when length(text_blocks) > 2 do
    new_text_blocks = merge(text_blocks, [])
    TextDocument.replace_text_blocks(doc, new_text_blocks)
  end

  def merge([first | []], acc), do: [first | acc] |> Enum.reverse()

  def merge([first, second | tail], acc) do
    case first.text_density == second.text_density do
      true -> merge([TextBlock.merge(first, second) | tail], acc)
      _ -> merge([second | tail], [first | acc])
    end
  end
end
