require 'spec_helper'

describe ApplicationController do
  describe "without session information" do
    before(:each) do
      session[:username] = nil
      session[:password] = nil
    end
    it "should redirect to the login page" do
      { :get => "/events" }.should redirect_to(login_url)
    end
  end
end