# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include WillPaginate::ViewHelpers 

  def will_paginate_with_i18n(collection, options = {}) 
    will_paginate_without_i18n(collection, options.merge(
      :previous_label => I18n.t(:previous, :scope => :will_paginate),
      :next_label => I18n.t(:next, :scope => :will_paginate))) 
  end 
  alias_method_chain :will_paginate, :i18n  
  
  def title &block
    if block
      @title = block
    elsif @title
      @title.call
    end
  end

  def navigation &block
    if block
      @navigation = block
    elsif @navigation
      @navigation.call
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
