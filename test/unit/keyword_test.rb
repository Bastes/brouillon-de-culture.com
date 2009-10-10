require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  test "require word" do
    keyword = Keyword.create
    assert !keyword.valid?, "Should not be valid without a word"

    keyword = Keyword.create :word => ''
    assert !keyword.valid?, "Should not be valid with an empty word"
    
    keyword = Keyword.create :word => 'word'
    assert keyword.valid?
  end

  test "require an unique word" do
    base = Keyword.create :word => 'word'
    assert base.valid?

    keyword = Keyword.create :word => 'word'
    assert !keyword.valid?, "Should not be valid with a duplicate word"

    keyword = Keyword.create :word => 'another word'
    assert keyword.valid?
  end
end
