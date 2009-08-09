# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title &block
    if block
      @title = block
    elsif @title
      @title.call
    end
  end
end
