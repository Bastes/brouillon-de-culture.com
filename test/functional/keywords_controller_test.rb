require 'test_helper'

class KeywordsControllerTest < ActionController::TestCase
  should_route_ajax_actions

  context "as visitor" do
    should_do("on GET to :index", lambda { get :index }, :assigned => :keywords, :response => :success, :template => :index, :flash => false) do
      should "show all keywords ordered by importance" do
        assert assigns(:keywords).length == 20
        importance = nil
        assigns(:keywords).each do |keyword|
          assert keyword.posts.length <= importance if importance
          importance = keyword.posts.length
        end
      end
    end

    should_do("on GET to :show for any keyword", lambda { get :show, :id => (@keyword = Keyword.first).id }, :assigned => lambda { { :keyword => @keyword } }, :response => :success, :template => :show, :flash => false)

    should_be_kicked_out("GET to :new")        { get :new }
    should_be_kicked_out("GET to :edit")       { get :edit, :id => Keyword.first.id }
    should_be_kicked_out("GET to :remove")     { get :remove, :id => Keyword.first.id }
    should_be_kicked_out("POST to :create")    { post :create }
    should_be_kicked_out("PUT to :update")     { put :update, :id => Keyword.first.id }
    should_be_kicked_out("DELETE to :destroy") { delete :destroy, :id => Keyword.first.id }
  end

  context "as admin" do
    setup { login_as_admin }

    should_do("on GET to :new", lambda { get :new }, :assigned => :keyword, :response => :success, :template => :new, :flash => false) do
      should "provide an empty new keyword" do
        assert assigns(:keyword).new_record?
      end
    end

    should_do("on GET to :edit", lambda { get :edit, :id => (@keyword = Keyword.first).id }, :assigned => lambda { { :keyword => @keyword } }, :response => :success, :template => :edit, :flash => false)

    should_do("on GET to :remove", lambda { get :remove, :id => (@keyword = Keyword.first).id }, :assigned => lambda { { :keyword => @keyword } }, :response => :success, :template => :remove, :flash => false)

    should_do("on valid POST (to :create)", lambda { post :create, :keyword => { :word => (@word ='random word') } }, :assigned => :keyword, :redirect => { "the new keyword's page" => lambda { assigns(:keyword) } }, :flash => /./) do
      should "set the keyword to the right word" do
        assert assigns(:keyword).word == @word
      end
    end

    should_do("on invalid POST (to :create)", lambda { post :create, :keyword => { :word => '' } }, :assigned => :keyword, :response => 422, :template => :new, :flash => false) do
      should "set the keyword to the faulty word" do
        assert assigns(:keyword).word == ''
      end
    end


    should_do("on valid POST (to :update)", lambda { put :update, :id => (@keyword = Keyword.first).id, :keyword => { :word => (@word ='random word') } }, :assigned => lambda { { :keyword => @keyword } }, :redirect => { "the keyword's page" => lambda { @keyword } }, :flash => /./) do
      should "set the keyword to the right word" do
        assert assigns(:keyword).word == @word
      end
    end

    should_do("on invalid POST (to :update)", lambda { put :update, :id => (@keyword = Keyword.first).id, :keyword => { :word => '' } }, :assigned => lambda { { :keyword => @keyword } }, :response => 422, :template => :edit, :flash => false) do
      should "set the keyword to the faulty word" do
        assert assigns(:keyword).word == ''
      end
    end

    should_do("on DELETE (to :destroy)", lambda { delete :destroy, :id => (@keyword = Keyword.first).id }, :redirect => { "the keywords page" => lambda { keywords_url } }, :flash => /./) do
      should "have deleted the keyword" do
        assert ! Keyword.exists?(@keyword.id)
      end
    end

  end
end
