defmodule Boilerpipe.SAX.PreprocessorTest do
  use ExUnit.Case

  test "strip/1 strips script tags" do
    text = "\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script>boom"
    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output = "\n\tboom"
  end

  test "strip/1 doesnt take too much" do
    text =
      "\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script>boom<script>alert()</script>"

    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output = "\n\tboom"
  end
end
