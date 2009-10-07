require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  test "require word" do
    k = Keyword.create
    assert !k.valid?, "Should not be valid without a word"

    k = Keyword.create :word => ''
    assert !k.valid?, "Should not be valid with an empty word"
    
    k = Keyword.create :word => 'word'
    assert k.valid?
  end

  test "require an unique word" do
    base = Keyword.create :word => 'word'
    assert base.valid?

    k = Keyword.create :word => 'word'
    assert !k.valid?, "Should not be valid with a duplicate word"

    k = Keyword.create :word => 'another word'
    assert k.valid?
  end
end
