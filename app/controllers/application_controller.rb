# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  filter_parameter_logging :login, :password

  protected

  def logout
    session[:login]    = nil
    session[:password] = nil
    redirect_to login_path
  end

  def is_admin? login = nil, password = nil
    if params[:login] and admin params[:password]
      session[:login]    = params[:login]
      session[:password] = params[:password]
    end
    ADMIN_LOGIN == session[:login] and ADMIN_PASSWORD == session[:password]
  end

  def as_admin
    redirect_to login_path unless is_admin?
  end
end
