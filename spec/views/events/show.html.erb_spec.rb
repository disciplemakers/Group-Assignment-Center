require 'spec_helper'

describe "events/show.html.erb" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :remote_event_id => 1,
      :remote_report_id => 1,
      :location_id => 1,
      :group_id => 1
    ))
    @remote_registrants = {12345678 => {"Gender"               => "M",
                                        "ConfirmationNumber"   => 12345678,
                                        "SchoolName"           => "Some University",
                                        "HousingAssignment"    => nil,
                                        "LastName"             => "Doe",
                                        "GraduationYear"       => 2018,
                                        "FirstName"            => "John",
                                        "CampusGroupRoom"      => nil,
                                        "SmallGroupAssignment" => nil,
                                        "RegistrationType"     => "Student"}}
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
