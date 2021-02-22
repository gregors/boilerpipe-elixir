defmodule Boilerpipe.SAX.Preprocessor do
  def strip(text) do
    text
    |> String.replace(~r/<script.+?<\/script>/mis, "")
    |> String.replace(~r/&nbsp;?/mis, " ")
    |> String.replace(~r/<svg.+?<\/svg>/is, "")
    |> String.replace(~r/<link.+?\/>/is, "")
    |> String.replace(~r/<meta[^>]+>/is, "")
    |> String.replace(~r/<style.+?<\/style>/is, "")
    |> String.replace(~r/<!\-\-.+?\-\->/is, "")
    |> String.replace(~r/\n/is, " ")
    |> String.replace(~r/\r/is, "")
    |> String.replace(~r/\t/is, " ")
  end
end
