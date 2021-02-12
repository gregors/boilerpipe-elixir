defmodule DefaultExtractorTest do
  use ExUnit.Case

  alias Boilerpipe.Extractors.Default

#  test "extracts text from html" do
#    text = Default.text("<html><head></head><body><div>This is so rad!!!</div></body></html>")
#    assert text == "This is so rad!!!"
#  end

  test "extracts text from html2" do
    Application.ensure_all_started(:inets)

    {:ok, {_status, _headers, body}} = :httpc.request(:get, {'https://blog.carbonfive.com/2017/08/28/always-squash-and-rebase-your-git-commits/', []}, [], [body_format: :binary]) |> IO.inspect
    body |> IO.inspect
    text = Default.text(body)
    assert text == "This is so rad!!!"
  end
end
