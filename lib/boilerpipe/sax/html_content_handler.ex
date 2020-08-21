defmodule Boilerpipe.SAX.HtmlContentHandler do
  @behaviour Saxy.Handler

  # tag_actions = ::Boilerpipe::SAX::TagActionMap.tag_actions
  def new do
    %{
      label_stacks: [],
      tag_actions: %{},
      tag_level: 0,
      text_buffer: [],
      token_buffer: [],
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
      text_blocks: [],
      last_event: nil
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

    # TODO: get atom via a mapping function
    tag = name |> String.upcase()
    tag_action = state.tag_actions[tag]

    new_state =
      case tag_action do
        nil ->
          %{state | flush: true}

        tag_action ->
          new_flush = tag_action.end_tag(name) || state.flush
          %{state | flush: new_flush}
      end

    tag_level =
      cond do
        tag_action == nil -> true
        tag_action.changes_tag_level == true -> true
        true -> false
      end

    state = flush_block(state)

    [_head | label_stacks] = state.label_stacks

    new_state = %{
      new_state
      | tag_level: tag_level,
        last_event: :END_TAG,
        label_stacks: label_stacks,
        last_end_tag: tag
    }

    {:ok, new_state}
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

  def characters(%{in_ignorable_element?: true} = state, _text), do: state
  def characters(state, text) when is_binary(text) and byte_size(text) < 1, do: state

  def characters(state, text) do
    state = flush_block(state)

    # replace all whitespace with simple space
    text = String.replace(text, ~r/\s+/, " ")

    # trim whitespace
    started_with_whitespace = text =~ ~r/^\s/
    ended_with_whitespace = text =~ ~r/\s$/
    text = String.trim(text)

    #  add a single space if the block was only whitespace
    case byte_size(text) == 0 do
      true ->
        append_space(state)

      false ->
        state
        |> update_block_level()
        |> append_space(started_with_whitespace)
        |> append_text(text)
        |> append_space(ended_with_whitespace)
    end
  end

  def update_block_level(%{block_tag_level: -1} = state) do
    IO.puts("-1 setting block level tag_level: #{state.tag_level}")
    %{state | block_tag_level: state.tag_level}
  end

  def update_block_level(state), do: state

  def append_space(%{last_event: :WHITESPACE} = state), do: state

  def append_space(state, false), do: state

  def append_space(
        %{text_buffer: text_buffer, token_buffer: tokens} = state,
        _should_append = true
      ) do
    %{
      state
      | last_event: :WHITESPACE,
        text_buffer: [" ", text_buffer],
        token_buffer: [" ", tokens]
    }
  end

  def append_text(%{text_buffer: text_buffer, token_buffer: tokens} = state, text) do
    %{
      state
      | last_event: :CHARACTERS,
        text_buffer: [text, text_buffer],
        token_buffer: [text, tokens]
    }
  end

  def flush_block(%{flush: false} = state), do: state

  def flush_block(%{flish: true} = state) do
    state
  end
end
