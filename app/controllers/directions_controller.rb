class DirectionsController < ApplicationController
  include RestStandards

  before_filter :as_admin, :except => [:hot, :index, :show]

  def index
    @directions = Direction.by_creation_date.all
  end

  def hot
    @directions = Direction.by_creation_date.top.all
    render :action => :index
  end

  def show
    @direction = Direction.find params[:id]
  end
end
