defmodule Boilerpipe.Document.TextDocument do
  alias Boilerpipe.Document.TextBlock

  def new(title, text_blocks) when is_list(text_blocks) do
    %{title: title, text_blocks: text_blocks}
  end

  def content(%{} = td) do
    text(td, true, false)
  end

  def text(%{text_blocks: text_blocks}, include_content, include_noncontent) do
    text_blocks
    |> Enum.filter(fn tb ->
      case {tb.content, include_content, include_noncontent} do
        {true, true, _} -> true
        {false, _, true} -> true
        {_, _, _} -> false
      end
    end)
    |> Enum.map(fn tb -> tb.text end)
    |> Enum.join("\n")
  end

  def debug_s(%{text_blocks: text_blocks}) do
    text_blocks
    |> Enum.map(fn tb -> TextBlock.to_s(tb) end)
    |> Enum.join("\n")
  end

  def replace_text_blocks(%{text_blocks: _text_blocks} = td, new_blocks) do
    %{td | text_blocks: new_blocks}
  end
end
