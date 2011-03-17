require 'spec_helper'

describe Assignment do
  before(:each) do
    @assignment = stub_model(Assignment, :group_id  => '1',
                                         :person_id => '37')
    @group = stub_model(Group, :id => "1")
    @person = stub_model(Person, :id => "37")
  end
  
  it "is invalid without a group_id" do
    @assignment.group_id = nil
    @assignment.should be_invalid
  end
  
  it "is invalid without a person_id" do
    @assignment.person_id = nil
    @assignment.should be_invalid
  end
  
  describe "to a group that has a capacity" do
    before(:each) do
      @group.capacity = 7
    end
    it "is invalid if the group is already at capacity" do
      @group.stub(:people).and_return(%w{ john paul george ringo tom dick harry })
      @assignment.should be_invalid
    end
    
    it "is valid if the group is below capacity" do
      @group.stub(:people).and_return(%w{ john paul george ringo })
      @assignment.should be_valid
    end
  end
  
  describe "to a group that has a gender constraint" do
    describe "of 'M' or 'F'" do
      it "is valid if the person's gender matches"
      it "is invalid if the person's gender does not match"
    end
    
    describe "of 'single-gender'" do
      it "is valid if no one else is in the group yet"
      it "is valid if the person's gender matches that of people already in the group"
      it "is invalid if the person's gender does not match that of people already in the group"
    end
  end
  
  describe "to a group that has a unique membership constraint" do
    it "is valid if the user isn't already assigned to a group bound by the constraint"
    it "is invalid if the user is already assigned to a group bound by the constraint"  
  end
  
end
