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
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 8
  end
end
