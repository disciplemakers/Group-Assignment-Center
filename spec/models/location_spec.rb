require 'spec_helper'

describe Location do
  before(:each) do
    @location = stub_model(Location, :id => 1)
    @event = mock_model(Event, :id          => 1,
                               :location_id => 1)
    Event.stub(:find).with(:all, :conditions => {:location_id => 1}).and_return([@event])
    
    @group = mock_model(Group, :id          => 1,
                               :name        => "Group 1",
                               :location_id => 1) 
    Group.stub(:find).with(:all, :conditions => {:location_id => 1}).and_return([@group])
  end
  
  describe "when destroyed" do
    it "should clear associated location_id field in events" do
      @group.stub(:update_attribute).with("location_id", nil)
      @event.should_receive(:update_attribute).with("location_id", nil)
      
      @location.clear_location_data
    end
    
    it "should clear associated location_id field in groups" do
      @event.stub(:update_attribute).with("location_id", nil)
      @group.should_receive(:update_attribute).with("location_id", nil)
      
      @location.clear_location_data
    end
  end
end
