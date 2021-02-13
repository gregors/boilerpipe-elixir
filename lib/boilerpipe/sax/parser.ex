defmodule Boilerpipe.SAX.Parser do
  def parse(html) do
    # preprocessing
    html = String.replace(html, ~r/<script.+<\/script>/is, "")

    state = Boilerpipe.SAX.HtmlContentHandler.new()
    Saxy.parse_string(html, Boilerpipe.SAX.HtmlContentHandler, state)
  end
end
