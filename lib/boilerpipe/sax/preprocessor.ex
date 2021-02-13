defmodule Boilerpipe.SAX.Preprocessor do
  def strip(text) do
    String.replace(text, ~r/<script.+<\/script>/is, "")
  end
end
