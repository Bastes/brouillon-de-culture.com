class PostsController < ApplicationController
  include RestStandards

  before_filter :as_admin, :except => [:index, :show]

  def index
    @posts = Post.by_creation_date.with_keywords.all
  end

  def show
    @post = Post.with_keywords.find params[:id]
  end
end
