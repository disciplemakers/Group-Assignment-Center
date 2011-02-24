require 'spec_helper'

describe Group do
  before(:each) do
    @group = stub_model(Group, :name => 'Group')
  end
  
  it "is invalid without a name" do
    @group.name = nil
    @group.should be_invalid
  end
  
  it "is valid with a nil capacity" do
    @group.capacity = nil
    @group.should be_valid
  end
  
  it "is invalid with a non-numeric capacity" do
    @group.capacity = 'string'
    @group.should be_invalid
  end
  
  it "is invalid with a negative capacity" do
    @group.capacity = -1
    @group.should be_invalid
  end
  
  it "is invalid with a non-integer capacity" do
    @group.capacity = 1.5
    @group.should be_invalid
  end
end
