require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "require title" do
    p = Post.create :text => "blah blah blah"
    assert !p.valid?, "Should not be valid without a title"

    p = Post.create :title => '', :text => "blah blah blah"
    assert !p.valid?, "Should not be valid with a blank title"

    p = Post.create :title => 'fake title', :text => "blah blah blah"
    assert p.valid?
  end
  
  test "unique title" do
    base = Post.create :title => 'fake title', :text => "blah blah blah"
    assert base.valid?

    p = Post.create :title => base.title, :text => "blah blah blah"
    assert !p.valid?, "Should not be valid with duplicate title"

    p = Post.create :title => 'another title', :text => "blah blah blah"
    assert p.valid?
  end
  
  test "require text" do
    p = Post.create :title => 'fake title'
    assert !p.valid?, "Should not be valid without a text"

    p = Post.create :title => 'fake title', :text => ""
    assert !p.valid?, "Should not be valid with a blank text"

    p = Post.create :title => 'fake title', :text => "blah blah blah"
    assert p.valid?
  end

  test "order by creation date" do
    posts = Post.by_creation_date.all
    created_at = nil
    posts.each do |post|
      assert post.created_at <= created_at, "Should be ordered by creation date" if created_at
      created_at = post.created_at
    end
  end
end
