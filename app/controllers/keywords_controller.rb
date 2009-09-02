class KeywordsController < ApplicationController
  include RestStandards

  before_filter :as_admin, :except => [:index, :show]

  def index
    @keywords = Keyword.by_importance.with_posts.all
  end

  def show
    @keyword = Keyword.with_posts.find params[:id]
  end
end
