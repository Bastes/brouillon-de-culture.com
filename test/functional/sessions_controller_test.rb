require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  should_route :get, '/session/new', :controller => :session, :action => :new
  should_route :post, '/session', :controller => :session, :action => :create
  should_route :delete, '/session', :controller => :session, :action => :destroy
  
  # FIXME : could do with testing the /login and /logout routes
  
  context "any user" do
    should_do "GET to :new", lambda { get :new }, :response => :success, :template => :new, :flash => false
  end

  context "user trying to login" do
    context "without the proper credentials" do
      should_be_kicked_out("POST to :create") { post :create, :login => 'anyone', :password => 'er, what ?' }
    end

    context "with the proper credentials" do
      should_do("POST to :create", lambda { post :create, :login => ADMIN_LOGIN, :password => ADMIN_PASSWORD }, :redirect => { "the post's index page" => lambda { posts_url } }, :flash => /./) do
        should "keep the credentials in the session" do
          # FIXME
        end
      end
    end
  end

  context "admin trying to logout" do
    # FIXME 
  end
end
