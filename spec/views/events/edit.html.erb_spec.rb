require 'spec_helper'

describe "events/edit.html.erb" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :remote_event_id => 1,
      :remote_report_id => 1,
      :location_id => 1,
      :group_id => 1
    ))
    
    # The view looks up the name of the event via the group,
    # so we need to stub the group.
    @group = assign(:group, mock_model(Group, :name => "Test Event", :level => 1).as_null_object)
    Group.stub(:find).with(1).and_return(@group)
    
    # We also need a location.
    location = stub_model(Location, :name => "Test Location")
    Location.stub(:find).with(1).and_return(location)
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => event_path(@event), :method => "post" do
      assert_select "input#event_remote_event_id", :name => "event[remote_event_id]"
      assert_select "input#event_remote_report_id", :name => "event[remote_report_id]"
      assert_select "select#event_location_id", :name => "event[location_id]"
      assert_select "select#event_group_id", :name => "event[group_id]"
    end
  end
end
