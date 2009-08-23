# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title &block
    if block
      @title = block
    elsif @title
      @title.call
    end
  end

  def admin_area &block
    yield if is_admin?
  end

  def translate_with_scope value
    t value, :scope => [:views, self.controller_name]
  end
  alias :tws :translate_with_scope
end
