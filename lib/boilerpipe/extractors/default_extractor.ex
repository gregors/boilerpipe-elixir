defmodule Boilerpipe.Extractors.Default do
  def text(content) do
    doc = Boilerpipe.SAX.Parser.parse(content)
    doc = process(doc)
    doc.text_buffer |> Enum.join(" ")
  end

  def process(doc) do
    doc |> IO.inspect
    # merge adjacent blocks with equal text_density
    # doc = Boilerpipe.Filters.SimpleBlockFusionProcessor.process(doc)

    # merge text blocks next to each other
    # max_distance_1 = Boilerpipe.Filters.BlockProximityFusion.new(1, false, false)

    # marks text blocks as content / non-content using boilerpipe alg
    # Boilerpipe.Filters.DensityRulesClassifier.process(doc)
  end
end
