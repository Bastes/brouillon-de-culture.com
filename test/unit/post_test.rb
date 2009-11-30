require 'test_helper'

class PostTest < ActiveSupport::TestCase
  should_have_and_belong_to_many :keywords
  should_validate_uniqueness_of :title
  should_validate_presence_of :title
  should_validate_presence_of :text

  context "The whole list of posts ordered by creation date" do
    setup do
      @posts = Post.by_creation_date.all
    end

    should "be ordered by creation date" do
      created_at = nil
      @posts.each do |post|
        assert_operator post.created_at, :<=, created_at if created_at
        created_at = post.created_at
      end
    end
  end

  context "A post with keywords by word" do
    setup do
      @post = Post.create :keywords_by_word => 'blah, bloh, bleh'
    end

    should "show the right amount of keywords" do
      assert_equal @post.keywords.size, 3
    end

    should "show these keywords" do
      assert_equal @post.keywords.map(&:word), ['blah', 'bloh', 'bleh']
    end

    should "show these keywords by word" do
      assert_equal @post.keywords_by_word.split(/, /), ['blah', 'bloh', 'bleh']
    end
  end
end

