# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all

  helper_method :is_admin?

  protect_from_forgery

  filter_parameter_logging :login, :password

  protected

  def logout
    session[:login]    = nil
    session[:password] = nil
    flash[:notice] = t(:logged_out, :scope => :messages)
    redirect_to login_path
  end

  def is_admin?
    if params[:login] and params[:password]
      session[:login]    = params[:login]
      session[:password] = params[:password]
      if ADMIN_LOGIN == session[:login] and ADMIN_PASSWORD == session[:password]
        flash[:notice] = t(:logged_in, :scope => :messages)
      end
    end
    ADMIN_LOGIN == session[:login] and ADMIN_PASSWORD == session[:password]
  end

  def as_admin
    redirect_to login_path unless is_admin?
  end
end
