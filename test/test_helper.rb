ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module ActionController
  class TestCase
    def login_as_admin
      @request.session[:login] = ADMIN_LOGIN
      @request.session[:password] = ADMIN_PASSWORD
    end

    def self.should_route_ajax_actions
      route_base = controller_class.controller_name.to_sym
      should_route :get,    "/#{route_base}",          :controller => route_base, :action => :index
      should_route :get,    "/#{route_base}/new",      :controller => route_base, :action => :new
      should_route :post,   "/#{route_base}",          :controller => route_base, :action => :create
      should_route :get,    "/#{route_base}/1",        :controller => route_base, :action => :show,    :id => 1
      should_route :get,    "/#{route_base}/1/edit",   :controller => route_base, :action => :edit,    :id => 1
      should_route :put,    "/#{route_base}/1",        :controller => route_base, :action => :update,  :id => 1
      should_route :get,    "/#{route_base}/1/remove", :controller => route_base, :action => :remove,  :id => 1
      should_route :delete, "/#{route_base}/1",        :controller => route_base, :action => :destroy, :id => 1
    end

    def self.should_be_kicked_out description, &action_block
      context description do
        setup &action_block

        should_redirect_to("the login url") { login_url }
      end
    end

    def self.should_do description, action_block, *characteristics, &more_assertions
      characteristics = characteristics.first
      characteristics ||= {}

      context description do
        setup &action_block

        if characteristics.has_key? :assigned
          characteristics[:assigned] = characteristics[:assigned].bind(self).call if characteristics[:assigned].is_a? Proc
          characteristics[:assigned] = [characteristics[:assigned]] unless (characteristics[:assigned].is_a?(Array) or characteristics[:assigned].is_a?(Hash))
          characteristics[:assigned].each do |assigned, expected|
            if expected.nil?
              should_assign_to assigned
            else
              should_assign_to assigned { expected }
            end
          end
        end

        should_respond_with characteristics[:response] if characteristics[:response]
        should_render_template characteristics[:template] if characteristics[:template]
        should_redirect_to(characteristics[:redirect].keys.first, &characteristics[:redirect].values.first) if characteristics[:redirect]

        unless characteristics[:flash].nil?
          if characteristics[:flash]
            should_set_the_flash_to characteristics[:flash]
          else
            should_not_set_the_flash
          end
        end

        more_assertions.bind(self).call if block_given?
      end
    end
  end
end
