class SessionsController < ApplicationController
  before_filter :as_admin, :except => :new

  def new
  end

  def create
    redirect_to posts_path
  end

  def destroy
    logout
  end
end
