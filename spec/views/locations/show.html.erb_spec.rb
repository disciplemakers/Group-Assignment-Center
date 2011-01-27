require 'spec_helper'

describe "locations/show.html.erb" do
  before(:each) do
    assign(:location, stub_model(Location,
      :id => 2,
      :name => "Room",
      :parent_id => 1
    ))
    assign(:parent, stub_model(Location,
      :id => 1,
      :name => "House",
      :parent_id => 0
    ))
    assign(:location_relation, stub_model(LocationRelation,
      :parent_id => 1,
      :child_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Room/)
  end
  
  it "displays its own ID" do
    render
    rendered.should contain("2")
  end
  
  it "displays the name of its parent" do
    render
    rendered.should contain("House")
  end
end
