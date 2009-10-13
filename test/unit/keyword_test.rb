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

  test "order by importance" do
    keywords = Keyword.by_importance.all
    posts = nil
    keywords.each do |keyword|
      assert keyword.posts.count <= posts, 'Should be ordered by number of posts' if posts
      posts = keyword.posts.count
    end
  end

  test "only used" do
    assert Keyword.all.count == 20, 'Should match all 20 keywords'
    assert Keyword.only_used.all.count == 10, 'Should match only used keywords'
    Keyword.only_used.all.each do |keyword|
      assert keyword.posts.count > 0, 'Used keywords should have posts'
    end
  end
end
