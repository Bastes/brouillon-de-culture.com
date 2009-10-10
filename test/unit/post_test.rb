require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "require title" do
    post = Post.create :text => "blah blah blah"
    assert !post.valid?, "Should not be valid without a title"

    post = Post.create :title => '', :text => "blah blah blah"
    assert !post.valid?, "Should not be valid with a blank title"

    post = Post.create :title => 'fake title', :text => "blah blah blah"
    assert post.valid?
  end
  
  test "unique title" do
    base = Post.create :title => 'fake title', :text => "blah blah blah"
    assert base.valid?

    post = Post.create :title => base.title, :text => "blah blah blah"
    assert !post.valid?, "Should not be valid with duplicate title"

    post = Post.create :title => 'another title', :text => "blah blah blah"
    assert post.valid?
  end
  
  test "require text" do
    post = Post.create :title => 'fake title'
    assert !post.valid?, "Should not be valid without a text"

    post = Post.create :title => 'fake title', :text => ""
    assert !post.valid?, "Should not be valid with a blank text"

    post = Post.create :title => 'fake title', :text => "blah blah blah"
    assert post.valid?
  end

  test "order by creation date" do
    posts = Post.by_creation_date.all
    created_at = nil
    posts.each do |post|
      assert post.created_at <= created_at, "Should be ordered by creation date" if created_at
      created_at = post.created_at
    end
  end

  test "keywords by words" do
    post = Post.create :keywords_by_word => 'blah, bloh, bleh'
    assert post.keywords.size == 3
    assert post.keywords.map(&:word) == ['blah', 'bloh', 'bleh']
    assert post.keywords_by_word.split(/, /) == ['blah', 'bloh', 'bleh']
  end
end
