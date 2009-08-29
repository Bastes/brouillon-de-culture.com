class PostsController < ApplicationController
  include RestStandards

  before_filter :as_admin, :except => [:index, :show]
end
