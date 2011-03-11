require 'spec_helper'

describe "assignments/new.html.erb" do
  before(:each) do
    assign(:assignment, stub_model(Assignment,
      :group_id => 1,
      :person_id => 1
    ).as_new_record)
  end

  it "renders new assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assignments_path, :method => "post" do
      assert_select "input#assignment_group_id", :name => "assignment[group_id]"
      assert_select "input#assignment_person_id", :name => "assignment[person_id]"
    end
  end
end
