require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  should_route_ajax_actions

  context "as visitor" do
    should_do("on GET to :index", lambda { get :index }, :assigned => :posts, :response => :success, :template => :index, :flash => false) do
      should "show 5 posts ordered by date" do
        assert assigns(:posts).length == 5
        date = nil
        assigns(:posts).each do |current|
          assert current.created_at <= date if date
          date = current.created_at
        end
      end
    end

    should_do("on GET to :show for any post", lambda { get :show, :id => (@post = Post.first).id }, :assigned => lambda { { :post => @post } }, :response => :success, :template => :show, :flash => false)

    should_be_kicked_out("GET to :new")        { get :new }
    should_be_kicked_out("GET to :edit")       { get :edit, :id => Post.first.id }
    should_be_kicked_out("GET to :remove")     { get :remove, :id => Post.first.id }
    should_be_kicked_out("POST to :create")    { post :create }
    should_be_kicked_out("PUT to :update")     { put :update, :id => Post.first.id }
    should_be_kicked_out("DELETE to :destroy") { delete :destroy, :id => Post.first.id }
  end

  context "as admin" do
    setup { login_as_admin }

    should_do("on GET to :new", lambda { get :new }, :assigned => :post, :response => :success, :template => :new, :flash => false) do
      should "provide an empty new post" do
        assert assigns(:post).new_record?
      end
    end

    should_do("on GET to :edit", lambda { get :edit, :id => (@post = Post.first).id }, :assigned => lambda { { :post => @post } }, :response => :success, :template => :edit, :flash => false)

    should_do("on GET to :remove", lambda { get :remove, :id => (@post = Post.first).id }, :assigned => lambda { { :post => @post } }, :response => :success, :template => :remove, :flash => false)

    should_do("on valid POST (to :create)", lambda { post :create, :post => { :title => (@title = "blah blah"), :text => (@text = "blah blah blah blah") } }, :assigned => :post, :redirect => { "the new post's page" => lambda { assigns(:post) } }, :flash => /./) do
      should "set the post to the right title and text" do
        assert assigns(:post).title == @title
        assert assigns(:post).text == @text
      end
    end

    should_do("on invalid POST (to :create)", lambda { post :create, :post => { :title => '', :text => '' } }, :assigned => :post, :response => 422, :template => :new, :flash => false) do
      should "set the post to the right title and text" do
        assert assigns(:post).title == ''
        assert assigns(:post).text == ''
      end
    end

    should_do("on valid PUT (to :update)", lambda { put :update, :id => (@post = Post.first).id, :post => { :title => (@title = "blah blah"), :text => (@text = "blah blah blah blah") } }, :assigned => :post, :redirect => { "the new post's page" => lambda { assigns(:put) } }, :flash => /./) do
      should "set the post to the right title and text" do
        assert assigns(:post).title == @title
        assert assigns(:post).text == @text
      end
    end

    should_do("on invalid PUT (to :update)", lambda { put :update, :id => (@post = Post.first).id, :post => { :title => '', :text => '' } }, :assigned => :post, :response => 422, :template => :edit, :flash => false) do
      should "set the post to the right title and text" do
        assert assigns(:post).title == ''
        assert assigns(:post).text == ''
      end
    end

    should_do("on DELETE (to :destroy)", lambda { delete :destroy, :id => (@post = Post.first).id }, :redirect => { "the posts page" => lambda { posts_url } }, :flash => /./) do
      should "have deleted the post" do
        assert ! Post.exists?(@post.id)
      end
    end
  end
end
