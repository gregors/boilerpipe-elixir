defmodule Boilerpipe.Document.TextBlock do
  defstruct num_words: 0,
            num_words_in_wrapped_lines: 0,
            num_words_in_anchor_text: 0,
            num_wrapped_lines: 1,
            offset_blocks_start: 0,
            offset_blocks_end: 0,
            text: "",
            text_density: 0,
            link_density: 0.0,
            labels: %MapSet{},
            tag_level: 0,
            content: false

  def new(text, offset_blocks \\ 0) do
    %Boilerpipe.Document.TextBlock{
      text: text,
      offset_blocks_start: offset_blocks,
      offset_blocks_end: offset_blocks
    }
  end

  def set_tag_level(text_block, level) do
    %{text_block | tag_level: level}
  end

  def is_content?(text_block) do
    text_block.content
  end

  def is_not_content?(text_block) do
    !text_block.content
  end

  def add_label(text_block, label) do
    %{text_block | labels: MapSet.put(text_block.labels, label)}
  end

  def to_s(text_block) do
    labels =
      case Enum.empty?(text_block.labels) do
        true -> "null"
        _ -> text_block.labels |> MapSet.to_list() |> Enum.join(",")
      end

    "[#{text_block.offset_blocks_start}-#{text_block.offset_blocks_end};\
tl=#{text_block.tag_level}; \
nw=#{text_block.num_words};\
nwl=#{text_block.num_wrapped_lines};\
ld=#{text_block.link_density}]\t#{if text_block.content, do: "CONTENT", else: "BOILERPLATE"},#{
      labels
    }\n#{text_block.text}"
  end

  def merge(b1, b2) do
    new_block = %{
      b1
      | text: b1.text <> "\n" <> b2.text,
        num_words: b1.num_words + b2.num_words,
        num_words_in_anchor_text: b1.num_words_in_anchor_text + b2.num_words_in_anchor_text,
        num_words_in_wrapped_lines: b1.num_words_in_wrapped_lines + b2.num_words_in_wrapped_lines,
        num_wrapped_lines: b1.num_wrapped_lines + b2.num_wrapped_lines,
        offset_blocks_start: min(b1.offset_blocks_start, b2.offset_blocks_start),
        offset_blocks_end: max(b1.offset_blocks_end, b2.offset_blocks_end),
        content: b1.content || b2.content,
        labels: MapSet.union(b1.labels, b2.labels)
    }

    %{new_block | text_density: text_density(new_block), link_density: link_density(new_block)}
  end

  def link_density(block) do
    case block.num_words do
      0 -> 0.0
      _ -> block.num_words_in_anchor_text / block.num_words
    end
  end

  def text_density(block) do
    block.num_words_in_wrapped_lines / block.num_wrapped_lines
  end
end
