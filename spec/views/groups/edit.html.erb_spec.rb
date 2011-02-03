require 'spec_helper'

describe "groups/edit.html.erb" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :name => "MyString",
      :capacity => 1,
      :can_contain_people => false,
      :can_contain_groups => false,
      :location_id => 1,
      :comment => "MyText",
      :unique_membership => false,
      :required_membership => false,
      :gender_constraint_id => 1,
      :label_text => "MyString",
      :label_text_prepend_to_child_label => false,
      :label_field => 1
    ))
  end

  it "renders the edit group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => group_path(@group), :method => "post" do
      assert_select "input#group_name", :name => "group[name]"
      assert_select "input#group_capacity", :name => "group[capacity]"
      assert_select "input#group_can_contain_people", :name => "group[can_contain_people]"
      assert_select "input#group_can_contain_groups", :name => "group[can_contain_groups]"
      assert_select "input#group_location_id", :name => "group[location_id]"
      assert_select "textarea#group_comment", :name => "group[comment]"
      assert_select "input#group_unique_membership", :name => "group[unique_membership]"
      assert_select "input#group_required_membership", :name => "group[required_membership]"
      assert_select "input#group_gender_constraint_id", :name => "group[gender_constraint_id]"
      assert_select "input#group_label_text", :name => "group[label_text]"
      assert_select "input#group_label_text_prepend_to_child_label", :name => "group[label_text_prepend_to_child_label]"
      assert_select "input#group_label_field", :name => "group[label_field]"
    end
  end
end
