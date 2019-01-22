defmodule Boilerpipe.Document.TextBlock do
  defstruct num_words: 0,
            num_words_in_wrapped_lines: 0,
            num_words_in_anchor_text: 0,
            num_wrapped_lines: 0,
            offset_blocks_start: 0,
            offset_blocks_end: 0,
            text: "",
            text_density: 0,
            link_density: 0,
            labels: %MapSet{},
            tag_level: 0,
            num_full_text_words: 0,
            content: false

  def set_tag_level(text_block, level) do
    %{text_block | tag_level: level}
  end

  def is_content?(text_block) do
    text_block.content
  end

  def is_not_content?(text_block) do
    !text_block.content
  end

  def to_s(text_block) do
    labels =
      if Enum.empty?(text_block.labels),
        do: text_block.labels |> MapSet.to_list() |> Enum.join(","),
        else: "null"

    "[#{text_block.offset_blocks_start}-#{text_block.offset_blocks_end};\
    tl=#{text_block.tag_level}; \
    nw=#{text_block.num_words};\
    nwl=#{text_block.num_wrapped_lines};\
    ld=#{text_block.link_density}]\t#{
      if text_block.is_content?, do: "CONTENT", else: "BOILERPLATE"
    },#{labels}\n#{text_block.text}"
  end
end
