require 'test_helper'

class DirectionTest < ActiveSupport::TestCase
  test "require url" do
    direction = Direction.create
    assert !direction.valid?, "Should not be valid without an url"

    direction = Direction.create :url => ''
    assert !direction.valid?, "Should not be valid with a blank url"

    direction = Direction.create :url => 'http://blah.blah.com'
    assert direction.valid?
  end

  test "require an unique url" do
    base = Direction.create :url => "http://blah.blah.com"
    assert base.valid?

    direction = Direction.create :url => "http://blah.blah.com"
    assert !direction.valid?, "Should not be valid with a duplicate url"

    direction = Direction.create :url => "http://another.one.com"
    assert direction.valid?
  end

  test "actual name or url if none" do
    direction = Direction.new :name => 'url name', :url => 'http://blah.blah.com'
    assert direction.actual_name == direction.name, "Shoud return the name when the name's not blank"

    direction = Direction.new :url => 'http://blah.blah.com'
    assert direction.actual_name == direction.url, "Shoud return the url when there's no name"

    direction = Direction.new :name => '', :url => 'http://blah.blah.com'
    assert direction.actual_name == direction.url, "Shoud return the url when the name's blank"
  end

  test "description or actual name if none" do
    direction = Direction.new :name => 'url name', :url => 'http://blah.blah.com', :description => 'blah blah blah'
    assert direction.actual_description == direction.description, "Shoud return the description when the description's not blank"

    direction = Direction.new :name => 'url name', :url => 'http://blah.blah.com'
    assert direction.actual_description == direction.actual_name, "Shoud return the actual name when there's no description"

    direction = Direction.new :name => 'url name', :url => 'http://blah.blah.com', :description => ''
    assert direction.actual_description == direction.actual_name, "Shoud return the actual name when the description's blank"
  end
end
