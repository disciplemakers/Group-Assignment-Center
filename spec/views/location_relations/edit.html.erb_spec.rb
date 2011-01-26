require 'spec_helper'

describe "location_relations/edit.html.erb" do
  before(:each) do
    @location_relation = assign(:location_relation, stub_model(LocationRelation,
      :parent_id => 1,
      :child_id => 1
    ))
  end

  it "renders the edit location_relation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => location_relation_path(@location_relation), :method => "post" do
      assert_select "input#location_relation_parent_id", :name => "location_relation[parent_id]"
      assert_select "input#location_relation_child_id", :name => "location_relation[child_id]"
    end
  end
end
