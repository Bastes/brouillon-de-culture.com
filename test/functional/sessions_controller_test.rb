require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  should_route :get, '/session/new', :controller => :session, :action => :new
  should_route :post, '/session', :controller => :session, :action => :create
  should_route :delete, '/session', :controller => :session, :action => :destroy
end
