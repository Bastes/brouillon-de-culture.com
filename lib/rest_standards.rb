# standard rest operations factored out for slimmer
# controllers
module RestStandards
  def index
    eval("@#{model_name.pluralize} = #{model_name.classify}.find(:all)")
  end

  def show
    item
  end

  def new
    item
  end

  def create
    if item.save
      done 'create'
      redirect_to item
    else
      render :action => :new, :status => 422
    end
  end

  def edit
    item
  end

  def update
    if item.update_attributes(params[model_name.to_sym])
      done 'update'
      redirect_to item
    else
      render :action => :edit, :status => 422
    end
  end

  def remove
    item
  end

  def destroy
    redirect_to(item) and return if params[:cancel]
    item.destroy
    done 'delete'
    eval "redirect_to #{model_name.pluralize}_path"
  end

  protected

  def item
    if @item
      @item
    elsif params[:id]
      @item = eval "@#{model_name} = #{model_class_name}.find(params[:id])"
    elsif params[model_name.to_sym]
      @item = eval "@#{model_name} = #{model_class_name}.new params[:#{model_name}]"
    elsif params[:action] == 'new'
      @item = eval "@#{model_name} = #{model_class_name}.new"
    else
      @item = nil
    end
  end

  def done action
    flash[:notice] = t('messages.' + action + 'd',
                       :model => t('activerecord.models.' + model_name))
  end

  def model_name
    controller_name.singularize
  end

  def model_class_name
    model_name.classify
  end

  def model
    eval(model_class_name)
  end
end
