require 'spec_helper'

describe "people/show.html.erb" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :first_name => "First Name",
      :last_name => "Last Name",
      :gender => "Gender",
      :registration_type => "Registration Type",
      :school => "School",
      :graduation_year => "Graduation Year",
      :housing_assignment => "Housing Assignment",
      :small_group_assignment => "Small Group Assignment",
      :campus_group_room => "Campus Group Room"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Last Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Gender/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Registration Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/School/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Graduation Year/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Housing Assignment/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Small Group Assignment/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Campus Group Room/)
  end
end
