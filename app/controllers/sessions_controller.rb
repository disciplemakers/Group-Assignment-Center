require 'regonlineconnector'

class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    account_id = params[:account_id]
    account_id = APP_CONFIG['account_id'] if account_id.nil?
    roc = RegonlineConnector.new(account_id, params[:username], params[:password])
    if roc.authenticate
      session[:username] = params[:username]
      session[:password] = params[:password]
      session[:account_id] = account_id
      redirect_to assign_events_path
    else
      redirect_to login_url, :alert => "Invalid username/password combination"
    end
  end

  def destroy
    session[:username] = nil
    session[:password] = nil
    session[:account_id] = nil
    redirect_to login_url, :alert => "Logged out"
  end

end
