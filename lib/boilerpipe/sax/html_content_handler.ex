defmodule Boilerpipe.SAX.HtmlContentHandler do
  @behaviour Saxy.Handler

  # tag_actions = ::Boilerpipe::SAX::TagActionMap.tag_actions
  def new do
    %{
      label_stacks: [],
      tag_actions: %{},
      tag_level: 0,
      sb_last_was_whitespace: false,
      text_buffer: "",
      token_buffer: "",
      offset_blocks: 0,
      flush: false,
      block_tag_level: -1,
      in_body: 0,
      in_anchor_tag: 0,
      in_ignorable_element: 0,
      in_anchor_text: false,
      font_size_stack: [],
      last_start_tag: "",
      title: "",
      text_blocks: []
    }
  end

  def handle_event(:start_document, _prolog, state) do
    IO.inspect("Start parsing document")
    {:ok, state}
  end

  def handle_event(:end_document, _data, state) do
    IO.inspect("Finish parsing document")
    {:ok, state}
  end

  def handle_event(:start_element, {name, attributes}, state) do
    IO.inspect("Start parsing element #{name} with attributes #{inspect(attributes)}")
    {:ok, [{:start_element, name, attributes} | state]}
  end

  def handle_event(:end_element, name, state) do
    IO.inspect("Finish parsing element #{name}")
    {:ok, [{:end_element, name} | state]}
  end

  def handle_event(:characters, chars, state) do
    IO.inspect("Receive characters #{chars}")
    {:ok, [{:chacters, chars} | state]}
  end
end
