require 'test_helper'

class DirectionTest < ActiveSupport::TestCase
  should_validate_presence_of :url
  should_validate_uniqueness_of :url

  context "A direction with " do
    context "no name nor description" do
      setup do
        @directions = [
          Direction.new(:url => 'http://fake.url.com'),
          Direction.new(:url => 'http://fake.url.com', :name => ''),
          Direction.new(:url => 'http://fake.url.com', :description => ''),
          Direction.new(:url => 'http://fake.url.com', :name => '', :description => '') ]
      end

      should "return the url as actual name" do
        @directions.each do |direction|
          assert direction.actual_name == direction.url
        end
      end
      
      should "return the url as actual description" do
        @directions.each do |direction|
          assert direction.actual_description == direction.url
        end
      end
    end

    context "a name" do
      context "but not description" do
        setup do
          @directions = [
            Direction.new(:url => 'http://fake.url.com', :name => 'fake name'),
            Direction.new(:url => 'http://fake.url.com', :name => 'fake name', :description => '') ]
        end

        should "return the name as actual name" do
          @directions.each do |direction|
            assert direction.actual_name == direction.name
          end
        end
        
        should "return the name as actual description" do
          @directions.each do |direction|
            assert direction.actual_description == direction.name
          end
        end
      end

      context "and a description" do
        setup do
          @direction = Direction.new(:url => 'http://fake.url.com', :name => 'fake name', :description => 'blah blah')
        end

        should "return the name as actual name" do
          assert @direction.actual_name == @direction.name
        end

        should "return the description as actual description" do
          assert @direction.actual_description == @direction.description
        end
      end
    end
  end

  context "The whole list of directions ordered by creation date" do
    setup do
      @directions = Direction.by_creation_date.all
    end

    should "be ordered by creation date" do
      created_at = nil
      @directions.each do |direction|
        assert direction.created_at <= created_at if created_at
        created_at = direction.created_at
      end
    end
  end
end
