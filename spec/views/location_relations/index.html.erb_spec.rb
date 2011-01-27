require 'spec_helper'

describe "location_relations/index.html.erb" do
  before(:each) do
    assign(:location_relations, [
      stub_model(LocationRelation,
        :parent_id => 1,
        :child_id => 1
      ),
      stub_model(LocationRelation,
        :parent_id => 1,
        :child_id => 1
      )
    ])
  end

  it "renders a list of location_relations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 4
  end
end
