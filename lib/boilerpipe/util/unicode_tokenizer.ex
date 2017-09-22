defmodule Boilerpipe.Util.UnicodeTokenizer do
  def tokenize(text) do
    # replace word boundaries with 'invisible separator'
    # strip invisible separators from non-word boundaries
    # replace spaces or invisible separators with a single space
    # trim
    # split words on spaces

    text
    |> String.replace(~r/\b/u, "\u{2063}")
    |> String.replace(~r/[\x{2063}]*(["'.,!@-\\:;$?()\/])[\x{2063}]*/u, "\\1")
    |> String.replace(~r/[ \x{2063}]+/u, " ")
    |> String.trim
    |> String.split(~r/[ ]+/u)
  end
end
