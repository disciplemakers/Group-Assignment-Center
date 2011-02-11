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
  
  describe "with parent" do
    before(:each) do
        @group.parent_id = 1
        @parent = Group.new(:id => 1, :name => 'Parent')
        Group.stub(:find).with(1).and_return(@parent)
    end
    
    describe "whose parent has unique membership constraint enabled" do
      before(:each) do
        @parent.unique_membership = true
      end
      
      it "is valid without unique membership constraint" do
        @group.unique_membership = nil
        @group.should be_valid
      end
      
      it "is invalid when unique membership constraint is enabled" do
        @group.unique_membership = true
        @group.should be_invalid
      end
      
      it "is invalid when unique membership constraint is disabled" do
        @group.unique_membership = false
        @group.should be_invalid
      end
    end
    
    
    describe "whose parent has unique membership constraint disabled" do
      before(:each) do
        @parent.unique_membership = false
      end
      
      it "is invalid without unique membership constraint" do
        @group.unique_membership = nil
        @group.should be_invalid
      end
      
      it "is valid when unique membership constraint is enabled" do
        @group.unique_membership = true
        @group.should be_valid
      end
      
      it "is valid when unique membership constraint is disabled" do
        @group.unique_membership = false
        @group.should be_valid
      end
    end
    
    describe "whose parent does not have unique membership constraint" do
      before(:each) do
        @parent.unique_membership = nil
      end
      
      it "is valid without unique membership constraint" do
        @group.unique_membership = nil
        @group.should be_valid
      end
      
      it "is invalid when unique membership constraint is enabled" do
        @group.unique_membership = true
        @group.should be_invalid
      end
      
      it "is invalid when unique membership constraint is disabled" do
        @group.unique_membership = false
        @group.should be_invalid
      end
  
    end
    
    describe "whose parent has required membership constraint enabled" do
      before(:each) do
        @parent.required_membership = true
      end
  
      it "is invalid without required membership constraint" do
        @group.required_membership = nil
        @group.should be_invalid
      end
      
      it "is invalid when required membership constraint is enabled" do
        @group.required_membership = true
        @group.should be_invalid
      end
      
      it "is valid when required membership constraint is disabled" do
        @group.required_membership = false
        @group.should be_valid      
      end
    end
  
    describe "whose parent has required membership constraint disabled" do
      before(:each) do
        @parent.required_membership = false
      end
      
      it "is invalid without required membership constraint" do
        @group.required_membership = nil
        @group.should be_invalid
      end  
      it "is invalid when required membership constraint is enabled" do
        @group.required_membership = true
        @group.should be_invalid
      end
      it "is valid when required membership constraint is disabled" do
        @group.required_membership = false
        @group.should be_valid
      end
    end
    
    describe "whose parent does not have required membership constraint" do
      before(:each) do
        @parent.required_membership = nil
      end
      
      it "is valid without required membership constraint" do
        @group.required_membership = nil
        @group.should be_valid
      end
      it "is valid when required membership constraint is enabled" do
        @group.required_membership = true
        @group.should be_valid
      end
      it "is invalid when required membership constraint is disabled" do
        @group.required_membership = false
        @group.should be_invalid
      end       
    end
  end
end
