require 'regonlineconnector'

class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    roc = RegonlineConnector.new(params[:account_id], params[:username], params[:password])
    if roc.authenticate
      session[:username] = params[:username]
      session[:password] = params[:password]
      session[:account_id] = params[:account_id] 
      redirect_to events_url
      print "session created!"
    else
      print "login failed"
      redirect_to login_url, :alert => "Invalid username/password combination"
    end
  end

  def destroy
  end

end
