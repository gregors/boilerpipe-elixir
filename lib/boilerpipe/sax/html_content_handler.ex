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
      last_end_tag: "",
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

  # we're not in body tag
  def flush_block(%{flush: true, in_body: 0} = state) do
    state = %{state | flush: false}

    if state.last_start_tag == :TITLE do
      title = state.token_buffer |> Enum.join(" ") |> String.trim()
      %{state | text_buffer: [], token_buffer: [], title: title}
    else
      state
    end
  end

  def flush_block(%{flush: true} = state) do
    state = %{state | flush: false}

    cond do
      state.token_buffer.size == 0 ->
        state

      state.token_buffer.size == 1 && state.last_event == :WHITESPACE ->
        %{state | text_buffer: [], token_buffer: []}

      true ->
        state
        num_words = 0
        num_words_current_line = 0
        num_words_in_wrapped_lines = 0
        num_wrapped_lines = 0
        num_linked_words = 0
        current_line_length = 0
        max_line_length = 80

        tokens =
          state.token_buffer
          |> Enum.join(" ")
          |> Boilerpipe.Util.UnicodeTokenizer.tokenize()

        tokens
        |> Enum.each(fn token ->
          cond do
            ANCHOR_TEXT_START == token ->
              %{state | in_anchor_text: true}

            ANCHOR_TEXT_END == token ->
              %{state | in_anchor_text: false}

            is_word?(token) ->
              num_words = num_words + 1
              num_words_current_line = num_words_current_line + 1

              num_linked_words =
                if state.in_anchor_text do
                  num_linked_words + 1
                else
                  num_linked_words
                end

              token_length = byte_size(token)
              current_line_length = current_line_length + token_length + 1

              if current_line_length > max_line_length do
                num_wrapped_lines = num_wrapped_lines + 1
                current_line_length = token_length
                num_words_current_line = 1
              end
          end
        end)

        #      return if tokens.empty?
        #
        num_words_in_wrapped_lines = 0

        if num_wrapped_lines == 0 do
          num_words_in_wrapped_lines = num_words
          num_wrapped_lines = 1
        else
          num_words_in_wrapped_lines = num_words - num_words_current_line
        end

        #      text_block = ::Boilerpipe::Document::TextBlock.new(@text_buffer.strip,
        #                                                         num_words,
        #                                                         num_linked_words,
        #                                                         num_words_in_wrapped_lines,
        #                                                         num_wrapped_lines, @offset_blocks)
        #
        #      @offset_blocks += 1
        #      clear_buffers
        #      text_block.set_tag_level(@block_tag_level)
        #      add_text_block(text_block)
        #      @block_tag_level = -1
    end
  end

  def is_word?(text) do
    true
  end
end
