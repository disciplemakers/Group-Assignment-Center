require "spec_helper"

describe AssignmentsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/events/1/assignments/new" }.should route_to(:controller => "assignments", :event_id => "1", :action => "new")
    end

    it "recognizes and generates #edit" do
      { :get => "/events/1/assignments/1/edit" }.should route_to(:controller => "assignments", :event_id => "1", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/events/1/assignments" }.should route_to(:controller => "assignments", :event_id => "1", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/events/1/assignments/1" }.should route_to(:controller => "assignments", :event_id => "1", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/events/1/assignments/1" }.should route_to(:controller => "assignments", :event_id => "1", :action => "destroy", :id => "1")
    end

  end
end
