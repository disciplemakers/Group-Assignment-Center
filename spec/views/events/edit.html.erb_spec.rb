require 'spec_helper'

describe "events/edit.html.erb" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :id => 1,
      :remote_event_id => 123456,
      :remote_report_id => 654321,
      :location_id => 1,
      :group_id => 1
    ))
    
    # The view looks up the name of the event via the group,
    # so we need to stub the group.
    @group = assign(:group, mock_model(Group, :name => "Test Event",
                                              :parent_id => nil,
                                              :location_id => nil))
    @group.stub(:self_and_descendants).with(no_args()).and_return(@group)
    @group.stub(:map).with(no_args()).and_return([@group])
    
    Group.stub(:find).with(1).and_return(@group)
    # We also need a location.
    location = stub_model(Location, :name => "Test Location")
    Location.stub(:find).with(1).and_return(location)
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => event_path(@event), :method => "post" do
      assert_select "input#event_remote_report_id", :name => "event[remote_report_id]"
      assert_select "input#group_event_group_id", :name => "group[event_group_id]"
      assert_select "select#group_parent_id", :name => "group[parent_id]"
      assert_select "select#group_id", :name => "group[id]"
      assert_select "select#group_location_id", :name => "group[location_id]"
    end
  end
end
