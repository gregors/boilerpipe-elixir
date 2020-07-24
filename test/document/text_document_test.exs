defmodule DocumentTextDocumentTest do
  use ExUnit.Case
  alias Boilerpipe.Document.TextDocument
  alias Boilerpipe.Document.TextBlock


  test ".new needs title and text_blocks" do
    tbs = [ TextBlock.new("one"), TextBlock.new("two") ]
    td = TextDocument.new("my title", tbs)
    assert td == %{title: "my title", text_blocks: tbs}
  end

  test ".content returns the content" do
    tbs =
      [ TextBlock.new("one"), TextBlock.new("two") ]
      |> Enum.map(fn tb -> %TextBlock{ tb | content: true } end)

    td = TextDocument.new("my title", tbs)
    assert TextDocument.content(td) == "one\ntwo"
  end

  test ".replace_text_blocks replaces blocks" do
    tbs = [ TextBlock.new("one"), TextBlock.new("two") ]
    td = TextDocument.new("my title", tbs)

    assert TextDocument.replace_text_blocks(td, []) == []
  end

  test ".debug_s returns detailed debug info" do
    tbs = [ TextBlock.new("one"), TextBlock.new("two") ]
    td = TextDocument.new("my title", tbs)

    assert TextDocument.debug_s(td) == "[0-0;tl=0; nw=0;nwl=1;ld=0.0]\tBOILERPLATE,null\none\n[0-0;tl=0; nw=0;nwl=1;ld=0.0]\tBOILERPLATE,null\ntwo"
  end
end
