defmodule DefaultExtractorTest do
  use ExUnit.Case

  alias Boilerpipe.Extractors.Default

  test "extracts text from html" do
    text = Default.text("<html><head></head><body><div>This is so rad!!!</div></body></html>")
    assert text == "This is so rad!!!"
  end
end
