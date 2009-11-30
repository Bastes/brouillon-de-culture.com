require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  should_have_and_belong_to_many :posts
  should_validate_presence_of :word
  should_validate_uniqueness_of :word

  context "The whole list of keywords ordered by importance" do
    setup do
      @keywords = Keyword.by_importance.all
    end

    should "be ordered by decreasing number of posts" do
      posts = nil
      @keywords.each do |keyword|
        assert_operator keyword.posts.count, :<=, posts if posts
        posts = keyword.posts.count
      end
    end
  end

  context "Only used keywords" do
    setup do
      @keywords = Keyword.only_used.all
    end

    should "have only used keywords" do
      @keywords.each do |keyword|
        assert_operator keyword.posts.count, :>, 0
      end
    end
  end

  context "Top keywords" do
    setup do
      @keywords = Keyword.top.all
    end

    should "show only 5 keywords" do
      assert_equal @keywords.length, 5
    end
  end
end
