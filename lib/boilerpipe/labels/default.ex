defmodule Boilerpipe.Labels.Default do
  :TITLE
  :ARTICLE_METADATA
  :INDICATES_END_OF_TEXT
  :MIGHT_BE_CONTENT
  :VERY_LIKELY_CONTENT
  :STRICTLY_NOT_CONTENT
  :HR
  :LI
  :HEADING
  :H1
  :H2
  :H3
  @markup_prefix "<"
  def markup_prefix, do: @markup_prefix
end
