require 'spec_helper'

describe "events/index.html.erb" do
  before(:each) do
    assign(:events, [
      stub_model(Event,
        :remote_event_id => 1,
        :remote_report_id => 1,
        :location_id => 1,
        :group_id => 1
      ),
      stub_model(Event,
        :remote_event_id => 1,
        :remote_report_id => 1,
        :location_id => 1,
        :group_id => 1
      )
    ])
    assign(:remote_events, {999999 => {"ID"           => 999999,
                                       "Status"       => "Testing",
                                       "Type"         => "Event",
                                       "ClientID"     => nil,
                                       "Title"        => "Test Conference",
                                       "LocationName" => "Conference Center",
                                       "Room"         => nil,
                                       "StartDate"    => nil,
                                       "EndDate"      => nil}})
   @group = assign(:group, stub_model(Group,
      :id => 1,
      :name => "Group Name"
   ))
   Group.stub(:find).with(any_args()).and_return(@group)
   @location = assign(:location, stub_model(Location,
      :id => 1,
      :name => "Location Name"
   ))
   Location.stub(:find).with(any_args()).and_return(@location)
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 4
  end
end
