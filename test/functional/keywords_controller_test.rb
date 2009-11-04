require 'test_helper'

class KeywordsControllerTest < ActionController::TestCase
  should_route_ajax_actions

  context "as visitor" do
    context "on GET to :index" do
      setup { get :index }

      should_assign_to :keywords
      should_respond_with :success
      should_render_template :index
      should_not_set_the_flash

      should "show all keywords ordered by importance" do
        assert assigns(:keywords).length == 20
        importance = nil
        assigns(:keywords).each do |keyword|
          assert keyword.posts.length <= importance if importance
          importance = keyword.posts.length
        end
      end
    end

    context "on GET to :show for any keyword" do
      setup { get :show, :id => (@keyword = Keyword.first).id }

      should_assign_to(:keyword) { @keyword }
      should_respond_with :success
      should_render_template :show
      should_not_set_the_flash
    end

    should_be_kicked_out("GET to :new")        { get :new }
    should_be_kicked_out("GET to :edit")       { get :edit, :id => Keyword.first.id }
    should_be_kicked_out("GET to :remove")     { get :remove, :id => Keyword.first.id }
    should_be_kicked_out("POST to :create")    { post :create }
    should_be_kicked_out("PUT to :update")     { put :update, :id => Keyword.first.id }
    should_be_kicked_out("DELETE to :destroy") { delete :destroy, :id => Keyword.first.id }
  end

  context "as admin" do
    setup { login_as_admin }

    context "on GET to :new" do
      setup { get :new }

      should_assign_to(:keyword)
      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash

      should "provide an empty new keyword" do
        assert assigns(:keyword).new_record?
      end
    end

    context "on GET to :edit for any keyword" do
      setup { get :edit, :id => (@keyword = Keyword.first).id }

      should_assign_to(:keyword) { @keyword }
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash
    end

    context "on GET to :remove for any keyword" do
      setup { get :remove, :id => (@keyword = Keyword.first).id }

      should_assign_to(:keyword) { @keyword }
      should_respond_with :success
      should_render_template :remove
      should_not_set_the_flash
    end

    context "on valid POST (to :create)" do
      setup { post :create, :keyword => { :word => (@word ='random word') } }

      should_assign_to(:keyword)
      should_redirect_to("the new keyword's page") { assigns :keyword }
      should_set_the_flash_to(/./)

      should "set the keyword to the right word" do
        assert assigns(:keyword).word == @word
      end
    end

    context "on invalid POST (to :create)" do
      setup { post :create, :keyword => { :word => '' } }

      should_assign_to(:keyword)
      should_respond_with 422
      should_render_template :new
      should_not_set_the_flash

      should "set the keyword to the faulty word" do
        assert assigns(:keyword).word == ''
      end
    end

    context "on valid PUT (to :update)" do
      setup { put :update, :id => (@keyword = Keyword.first).id, :keyword => { :word => (@word ='random word') } }

      should_assign_to(:keyword)
      should_redirect_to("the keyword's page") { @keyword }
      should_set_the_flash_to(/./)

      should "set the keyword to the right word" do
        assert assigns(:keyword).word == @word
      end
    end

    context "on invalid PUT (to :update)" do
      setup { put :update, :id => (@keyword = Keyword.first).id, :keyword => { :word => '' } }

      should_assign_to(:keyword)
      should_respond_with 422
      should_render_template :edit
      should_not_set_the_flash

      should "set the keyword to the faulty word" do
        assert assigns(:keyword).word == ''
      end
    end

    context "on DELETE (to :destroy)" do
      setup { delete :destroy, :id => (@keyword = Keyword.first).id }

      should_redirect_to("the keywords page") { keywords_url }
      should_set_the_flash_to(/./)

      should "have deleted the keyword" do
        assert ! Keyword.exists?(@keyword.id)
      end
    end

  end
end
