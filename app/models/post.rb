class Post < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :text

  has_and_belongs_to_many :keywords

  def keywords_by_word= words
    words = words.split(/\s*,\s*/) if words.respond_to? :split
    self.keywords = words.collect { |word|
      Keyword.find_by_word(word.strip) || Keyword.new(:word => word)
    }.compact
  end

  def keywords_by_word
    self.keywords.collect { |keyword| keyword.word }.join ', '
  end
end
