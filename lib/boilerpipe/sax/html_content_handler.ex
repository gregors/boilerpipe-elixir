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

  def handle_event(:start_element, {name, attrs}, state) do
    IO.inspect("Start parsing element #{name} with attributes #{inspect(attrs)}")
    new_state = %{state | label_stacks: [nil | state.label_stacks]}

    # TODO: get atom via a mapping function
    tag = name |> String.upcase()

    new_state =
      case state.tag_actions[tag] do
        {:ok, tag_action} ->
          tag_level = tag_level(tag_action, new_state)
          flush = tag_action.start(name, attrs) || new_state.flush
          %{new_state | tag_level: tag_level, flush: flush}

        _ ->
          %{new_state | tag_level: new_state.tag_level + 1, flush: true}
      end

    new_state = %{new_state | last_event: :START_TAG, last_start_tag: tag}

    {:ok, new_state}
  end

  def handle_event(:end_element, name, state) do
    IO.inspect("Finish parsing element #{name}")
    {:ok, [{:end_element, name} | state]}
  end

  def handle_event(:characters, chars, state) do
    IO.inspect("Receive characters #{chars}")
    {:ok, [{:chacters, chars} | state]}
  end

  def tag_level(tag_action, state) do
    if tag_action.changes_tag_level do
      state.tag_level + 1
    else
      state.tag_level
    end
  end
end
