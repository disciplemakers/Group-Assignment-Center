require 'spec_helper'

describe "people/index.html.erb" do
  before(:each) do
    assign(:people, [
      stub_model(Person,
        :first_name => "First Name",
        :last_name => "Last Name",
        :gender => "Gender",
        :registration_type => "Registration Type",
        :school => "School",
        :graduation_year => "Graduation Year",
        :housing_assignment => "Housing Assignment",
        :small_group_assignment => "Small Group Assignment",
        :campus_group_room => "Campus Group Room"
      ),
      stub_model(Person,
        :first_name => "First Name",
        :last_name => "Last Name",
        :gender => "Gender",
        :registration_type => "Registration Type",
        :school => "School",
        :graduation_year => "Graduation Year",
        :housing_assignment => "Housing Assignment",
        :small_group_assignment => "Small Group Assignment",
        :campus_group_room => "Campus Group Room"
      )
    ])
  end

  it "renders a list of people" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Registration Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "School".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Graduation Year".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Housing Assignment".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Small Group Assignment".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Campus Group Room".to_s, :count => 2
  end
end
