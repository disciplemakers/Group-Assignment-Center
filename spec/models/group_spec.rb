require 'spec_helper'

describe Group do
  
  describe "parent with unique membership set to true" do 
    it "allows creation of a child with nil unique membership"
    it "allows setting a child's unique membership to nil"
    it "raises an error when setting a child's unique membership to true"
    it "raises an error when creating a child with unique membership set to true"
    it "raises an error when setting a child's unique membership to false"
    it "raises an error when creating a child with unique membership set to false"
    it "initializes child with nil unique membership when no value given"
  end
  
  describe "parent has unique membership set to false" do
    it "allows creation of a child with true unique membership"
    it "allows setting a child's unique membership to true"
    it "allows creation of a child with false unique membership"
    it "allows setting a child's unique membership to false"
    it "raises an error when setting a child's unique membership to nil"
    it "raises an error when creating a child with nil unique membership"
    it "initializes child with false unique membership when no value given"
  end
  
  describe "parent has nil unique membership" do
    it "allows creation of a child with nil unique membership"
    it "allows setting a child's unique membership to nil"
    it "raises an error when setting a child's unique membership to true"
    it "raises an error when creating a child with unique membership set to true"
    it "raises an error when setting a child's unique membership to false"
    it "raises an error when creating a child with unique membership set to false"
    it "initializes child with nil unique membership when no value given"    
  end
  
  describe "parent has required membership set to true" do
    it "allows creation of a child with false required membership"
    it "allows setting a child's required membership to false"
    it "raises an error when setting a child's required membership to true"
    it "raises an error when creating a child with required membership set to true"
    it "raises an error when setting a child's required membership to nil"
    it "raises an error when creating a child with nil required membership"
    it "initializes child with false required membership when no value given"    
  end

  describe "parent has required membership set to false" do
    it "allows creation of a child with false required membership"
    it "allows setting a child's required membership to false"
    it "raises an error when setting a child's required membership to true"
    it "raises an error when creating a child with required membership set to true"
    it "raises an error when setting a child's required membership to nil"
    it "raises an error when creating a child with nil required membership"
    it "initializes child with false required membership when no value given"    
  end
  
  describe "parent has nil required membership" do
    it "allows creation of a child with nil required membership"
    it "allows setting a child's required membership to nil"
    it "allows creation of a child with true required membership"
    it "allows setting a child's required membership to true"
    it "raises an error when setting a child's required membership to false"
    it "raises an error when creating a child with required membership set to false"
    it "initializes child with nil required membership when no value given"    
  end
  
end
