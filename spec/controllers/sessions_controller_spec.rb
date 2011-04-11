require 'spec_helper'

describe SessionsController do

  before(:each) do
    @mock_roc = mock('RegonlineConnector')
    RegonlineConnector.stub(:new).with(any_args()).and_return(@mock_roc)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    describe "if authentication fails" do
      before(:each) do
        @mock_roc.stub(:authenticate).with(no_args()).and_return(false)
      end
      
      it "should redirect to the login page" do
        get 'create'
        response.should redirect_to(login_url)
      end
    end
    
    describe "if authentication is successful"
      it "should redirect to the assign events page" do
        @mock_roc.stub(:authenticate).with(no_args()).and_return(true)
        get 'create'
        response.should redirect_to(assign_events_path)
      end
  end

  describe "GET 'destroy'" do
    before(:each) do
      session[:username] = 'username'
      session[:password] = 'password'
      session[:account_id] = 123456
    end
    
    it "should clear the username from the session" do
      get 'destroy'
      session[:username].should be_nil
    end
    
    it "should clear the password from the session" do
      get 'destroy'
      session[:password].should be_nil
    end
    
    it "should clear the account_id from the session" do
      get 'destroy'
      session[:account_id].should be_nil
    end
    
    it "should redirect to the login page" do
      get 'destroy'
      response.should redirect_to(login_url)
    end
  end

end
