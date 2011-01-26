require "spec_helper"

describe LocationRelationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/location_relations" }.should route_to(:controller => "location_relations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/location_relations/new" }.should route_to(:controller => "location_relations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/location_relations/1" }.should route_to(:controller => "location_relations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/location_relations/1/edit" }.should route_to(:controller => "location_relations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/location_relations" }.should route_to(:controller => "location_relations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/location_relations/1" }.should route_to(:controller => "location_relations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/location_relations/1" }.should route_to(:controller => "location_relations", :action => "destroy", :id => "1")
    end

  end
end
