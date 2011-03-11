require 'spec_helper'

describe "assignments/show.html.erb" do
  before(:each) do
    @assignment = assign(:assignment, stub_model(Assignment,
      :group_id => 1,
      :person_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
