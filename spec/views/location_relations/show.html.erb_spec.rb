require 'spec_helper'

describe "location_relations/show.html.erb" do
  before(:each) do
    @location_relation = assign(:location_relation, stub_model(LocationRelation,
      :parent_id => 1,
      :child_id => 1
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
