require 'spec_helper'

describe "locations/edit.html.erb" do
  before(:each) do
    @location = assign(:location, mock_model(Location,
      :id => 1,
      :name => "Test Location",
      :parent_id => nil,
      :capacity  => nil,
      :comment   => nil
    ))
    @location.stub(:self_and_descendants).with(no_args()).and_return(@location)
    @location.stub(:map).with(no_args()).and_return([@location])
    
    Location.stub(:find).with(1).and_return(@location)
  end
  
  it "renders the edit location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => location_path(@location), :method => "post" do
      assert_select "input#location_name", :name => "location[name]"
    end
  end
end
