defmodule UnicodeTokenizerTest do
  use ExUnit.Case
  alias Boilerpipe.Util.UnicodeTokenizer

  test "tokenizes words" do
    input = "How are you?"
    output = UnicodeTokenizer.tokenize(input)
    assert output == ["How", "are", "you?"]
  end

  test "splits on the unicode hidden separator" do
    input = "How\u{2063}are\u{2063}you?"
    output = UnicodeTokenizer.tokenize(input)
    assert output == ["How", "are", "you?"]
  end

  test "leaves symbols" do
    input = "How @@re 'y()u?'"
    output = UnicodeTokenizer.tokenize(input)
    assert output == ["How", "@@re", "'y()u?'"]
  end
end
