class PostsController < ApplicationController
  include RestStandards

  before_filter :as_admin, :except => [:hot, :index, :show]

  def index
    @posts = Post.by_creation_date.with_keywords.all
  end

  def hot
    @posts = Post.by_creation_date.with_keywords.top.all
    render :action => :index
  end

  def show
    @post = Post.with_keywords.find params[:id]
  end
end
