defmodule Boilerpipe.SAX.PreprocessorTest do
  use ExUnit.Case

  test "strip/1 strips script tags" do
    text = "\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script>boom"
    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output == "\n\t\tboom"
  end

  test "strip/1 strips script tags 2" do
    text =
      "\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script><div>boom</div>\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script>"

    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output == "\n\t\t<div>boom</div>\n\t\t"
  end

  test "strip/1 strips script tags 3" do
    text =
      "\n\t\t<script type=\"text/javascript\">for(i=0;i<5 && i>-1;i++){console.log(i)}</script><div>boom</div>\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script>"

    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output == "\n\t\t<div>boom</div>\n\t\t"
  end

  test "strip/1 strips meta tags" do
    text =
      "<head>\n    <meta charset=\"utf-8\">\nboom<meta http-equiv=\"x-ua-compatible\" content=\"ie=edge\">\n    "

    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output == "<head>\n    \nboom\n    "
  end

  test "strip/1 doesnt take too much" do
    text =
      "\n\t\t<script type=\"text/javascript\">\n\t\t\twindow._wpemojiSettings</script>boom<script>alert()</script>"

    output = Boilerpipe.SAX.Preprocessor.strip(text)
    assert output == "\n\t\tboom"
  end
end
