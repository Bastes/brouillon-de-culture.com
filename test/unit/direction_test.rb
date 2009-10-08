require 'test_helper'

class DirectionTest < ActiveSupport::TestCase
  test "require url" do
    d = Direction.create
    assert !d.valid?, "Should not be valid without an url"

    d = Direction.create :url => ''
    assert !d.valid?, "Should not be valid with a blank url"

    d = Direction.create :url => 'http://blah.blah.com'
    assert d.valid?
  end

  test "require an unique url" do
    base = Direction.create :url => "http://blah.blah.com"
    assert base.valid?

    d = Direction.create :url => "http://blah.blah.com"
    assert !d.valid?, "Should not be valid with a duplicate url"

    d = Direction.create :url => "http://another.one.com"
    assert d.valid?
  end

  test "actual name or url if none" do
    d = Direction.new :name => 'url name', :url => 'http://blah.blah.com'
    assert d.actual_name == d.name, "Shoud return the name when the name's not blank"

    d = Direction.new :url => 'http://blah.blah.com'
    assert d.actual_name == d.url, "Shoud return the url when there's no name"

    d = Direction.new :name => '', :url => 'http://blah.blah.com'
    assert d.actual_name == d.url, "Shoud return the url when the name's blank"
  end

  test "description or actual name if none" do
    d = Direction.new :name => 'url name', :url => 'http://blah.blah.com', :description => 'blah blah blah'
    assert d.actual_description == d.description, "Shoud return the description when the description's not blank"

    d = Direction.new :name => 'url name', :url => 'http://blah.blah.com'
    assert d.actual_description == d.actual_name, "Shoud return the actual name when there's no description"

    d = Direction.new :name => 'url name', :url => 'http://blah.blah.com', :description => ''
    assert d.actual_description == d.actual_name, "Shoud return the actual name when the description's blank"
  end
end
