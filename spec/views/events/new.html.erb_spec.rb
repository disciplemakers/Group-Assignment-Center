require 'spec_helper'

describe "events/new.html.erb" do
  before(:each) do
    assign(:event, stub_model(Event,
      :remote_event_id => 1,
      :remote_report_id => 1,
      :location_id => 1,
      :group_id => 1
    ).as_new_record)
  end

  it "renders new event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => events_path, :method => "post" do
      assert_select "input#event_remote_report_id", :name => "event[remote_report_id]"
    end
  end
end
