require 'spec_helper'

describe "locations/show.html.erb" do
  before(:each) do
    @location = assign(:location,
                       stub_model(Location,
                                  :id => 2,
                                  :name => "Room"))
  end
                                  
  describe "with top-level location" do
    it "doesn't display the parent location" do
      render
      rendered.should_not contain("Parent:")
    end
  end
   

  describe "with child location" do
    it "displays the parent location" do
      @location.stub(:parent_id => 1)
      # Defining "parent" here mimics the behavior of Location as a
      # self-referencing tree.
      @location.stub(:parent).and_return(stub_model(Location,
                                                    :id => 1,
                                                    :name => "House",
                                                    :parent_id => nil))
      render
      rendered.should contain("Parent:")
    end                                       
  end
  
end
