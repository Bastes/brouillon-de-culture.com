module KeywordsHelper
  def short_keyword_list keywords
    keywords.collect { |keyword| link_to keyword.word, keyword }.join ', '
  end
end
