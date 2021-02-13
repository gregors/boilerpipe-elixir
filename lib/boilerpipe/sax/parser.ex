defmodule Boilerpipe.SAX.Parser do
  alias Boilerpipe.SAX.Preprocessor

  def parse(html) do
    html = Preprocessor.strip(html)
    state = Boilerpipe.SAX.HtmlContentHandler.new()
    Saxy.parse_string(html, Boilerpipe.SAX.HtmlContentHandler, state)
  end
end
