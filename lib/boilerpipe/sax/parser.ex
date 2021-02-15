defmodule Boilerpipe.SAX.Parser do
  alias Boilerpipe.SAX.Preprocessor

  def parse(html) do
    #html = Preprocessor.strip(html)
    #"boom" |> IO.inspect()
    #"boom" |> IO.inspect()
    #html |> IO.inspect()
    state = Boilerpipe.SAX.HtmlContentHandler.new
    handler = fn {event, data} -> IO.puts("#{event} - #{data}") end
    SaxHtml.parse(html, handler)
  end
end
