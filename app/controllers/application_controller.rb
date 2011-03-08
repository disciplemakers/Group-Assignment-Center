class ApplicationController < ActionController::Base
  before_filter :authorize, :set_sidebar_data
  protect_from_forgery
  
  protected
  
  def authorize
    unless session[:username] && session[:password]
      redirect_to login_url, :notice => "Please log in"
    end
  end
  
  def set_sidebar_data
    @sidebar_events = Event.all
    @sidebar_locations = Location.roots
  end
end
