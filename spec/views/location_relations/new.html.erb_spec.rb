require 'spec_helper'

describe "location_relations/new.html.erb" do
  before(:each) do
    assign(:location_relation, stub_model(LocationRelation,
      :parent_id => 1,
      :child_id => 1
    ).as_new_record)
  end

  it "renders new location_relation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => location_relations_path, :method => "post" do
      assert_select "input#location_relation_parent_id", :name => "location_relation[parent_id]"
      assert_select "input#location_relation_child_id", :name => "location_relation[child_id]"
    end
  end
end
