require 'test_helper'

class DirectionsControllerTest < ActionController::TestCase
  should_route_ajax_actions

  context "as visitor" do
    should_do("on GET to :index", lambda { get :index }, :assigned => :directions, :response => :success, :template => :index, :flash => false) do
      should "show all directions ordered by date" do
        assert assigns(:directions).length == 10
        date = nil
        assigns(:directions).each do |current|
          assert current.created_at <= date if date
          date = current.created_at
        end
      end
    end

    should_do("on GET to :show for any direction", lambda { get :show, :id => (@direction = Direction.first).id }, :assigned => lambda { { :direction => @direction } }, :response => :success, :template => :show, :flash => false)

    should_be_kicked_out("GET to :new")        { get :new }
    should_be_kicked_out("GET to :edit")       { get :edit, :id => Direction.first.id }
    should_be_kicked_out("GET to :remove")     { get :remove, :id => Direction.first.id }
    should_be_kicked_out("POST to :create")    { post :create }
    should_be_kicked_out("PUT to :update")     { put :update, :id => Direction.first.id }
    should_be_kicked_out("DELETE to :destroy") { delete :destroy, :id => Direction.first.id }
  end

  context "as admin" do
    setup { login_as_admin }

    should_do("on GET to :new", lambda { get :new }, :assigned => :direction, :response => :success, :template => :new, :flash => false) do
      should "provide an empty new direction" do
        assert assigns(:direction).new_record?
      end
    end

    should_do("on GET to :edit", lambda { get :edit, :id => (@direction = Direction.first).id }, :assigned => lambda { { :direction => @direction } }, :response => :success, :template => :edit, :flash => false)

    should_do("on GET to :remove", lambda { get :remove, :id => (@direction = Direction.first).id }, :assigned => lambda { { :direction => @direction } }, :response => :success, :template => :remove, :flash => false)

    should_do("on valid POST (to :create)", lambda { post :create, :direction => { :url => (@url = "blah blah"), :name => (@name = "blah blah blah blah"), :description => (@description = "blah blah blah blah blah blah") } }, :assigned => :direction, :redirect => { "the new direction's page" => lambda { assigns(:direction) } }, :flash => /./) do
      should "set the direction to the right url, name and description" do
        assert assigns(:direction).url == @url
        assert assigns(:direction).name == @name
        assert assigns(:direction).description == @description
      end
    end

    should_do("on invalid POST (to :create)", lambda { post :create, :direction => { :url => '', :name => '', :description => '' } }, :assigned => :direction, :response => 422, :template => :new, :flash => false) do
      should "set the direction to the right url, name and description" do
        assert assigns(:direction).url == ''
        assert assigns(:direction).name == ''
        assert assigns(:direction).description == ''
      end
    end

    should_do("on valid PUT (to :update)", lambda { put :update, :id => (@direction = Direction.first).id, :direction => { :url => (@url = "blah blah"), :name => (@name = "blah blah blah blah"), :description => (@description = "blah blah blah blah blah blah") } }, :assigned => :direction, :redirect => { "the new direction's page" => lambda { assigns(:put) } }, :flash => /./) do
      should "set the direction to the right url, name and description" do
        assert assigns(:direction).url == @url
        assert assigns(:direction).name == @name
        assert assigns(:direction).description == @description
      end
    end

    should_do("on invalid PUT (to :update)", lambda { put :update, :id => (@direction = Direction.first).id, :direction => { :url => '', :name => '', :description => '' } }, :assigned => :direction, :response => 422, :template => :edit, :flash => false) do
      should "set the direction to the right url, name and description" do
        assert assigns(:direction).url == ''
        assert assigns(:direction).name == ''
        assert assigns(:direction).description == ''
      end
    end

    should_do("on DELETE (to :destroy)", lambda { delete :destroy, :id => (@direction = Direction.first).id }, :redirect => { "the directions page" => lambda { directions_url } }, :flash => /./) do
      should "have deleted the direction" do
        assert ! Direction.exists?(@direction.id)
      end
    end
  end
end
