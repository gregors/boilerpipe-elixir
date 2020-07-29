defmodule Boilerpipe.SAX.Parser do
  def parse(html) do
    # html preparsing to fix weird stuff
    #
    state = Boilerpipe.SAX.HtmlContentHandler.new()
    Saxy.parse_string(html, Boilerpipe.SAX.HtmlContentHandler, state)
  end
end
