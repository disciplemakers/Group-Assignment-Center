require 'spec_helper'

describe "people/new.html.erb" do
  before(:each) do
    assign(:person, stub_model(Person,
      :first_name => "MyString",
      :last_name => "MyString",
      :gender => "MyString",
      :registration_type => "MyString",
      :school => "MyString",
      :graduation_year => "MyString",
      :housing_assignment => "MyString",
      :small_group_assignment => "MyString",
      :campus_group_room => "MyString"
    ).as_new_record)
  end

  it "renders new person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => people_path, :method => "post" do
      assert_select "input#person_first_name", :name => "person[first_name]"
      assert_select "input#person_last_name", :name => "person[last_name]"
      assert_select "input#person_gender", :name => "person[gender]"
      assert_select "input#person_registration_type", :name => "person[registration_type]"
      assert_select "input#person_school", :name => "person[school]"
      assert_select "input#person_graduation_year", :name => "person[graduation_year]"
      assert_select "input#person_housing_assignment", :name => "person[housing_assignment]"
      assert_select "input#person_small_group_assignment", :name => "person[small_group_assignment]"
      assert_select "input#person_campus_group_room", :name => "person[campus_group_room]"
    end
  end
end
