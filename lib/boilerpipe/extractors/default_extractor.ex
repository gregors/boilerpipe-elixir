defmodule Boilerpipe.Extractors.Default do
  #  def text(contents) do
  #      doc = ::Boilerpipe::SAX::BoilerpipeHTMLParser.parse(contents)
  #      doc = process(doc)
  #      doc.content
  #    end

  def process(_doc) do
    # merge adjacent blocks with equal text_density
    # doc = Boilerpipe.Filters.SimpleBlockFusionProcessor.process(doc)

    # merge text blocks next to each other
    # max_distance_1 = Boilerpipe.Filters.BlockProximityFusion.new(1, false, false)

    # marks text blocks as content / non-content using boilerpipe alg
    # Boilerpipe.Filters.DensityRulesClassifier.process(doc)
  end
end
