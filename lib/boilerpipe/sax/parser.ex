defmodule Boilerpipe.SAX.Parser do
  alias Boilerpipe.SAX.Preprocessor
  alias Boilerpipe.SAX.HtmlContentHandler

  def parse(html) do
    #html = Preprocessor.strip(html)
    #html |> IO.inspect()
    handler = fn {event, data, state} -> HtmlContentHandler.handle_event({event, data, state}) end

    state = Boilerpipe.SAX.HtmlContentHandler.new
    SaxHtml.parse(html, handler, state)
  end
end
