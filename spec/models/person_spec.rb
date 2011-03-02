require 'spec_helper'

describe Person do
  before(:each) do
    @person = stub_model(Person, :first_name => 'Joe',
                                 :last_name => 'Test')
  end
  
  it "is not valid without a first name" do
    @person.first_name = nil
    @person.should be_invalid    
  end
  
  it "is not valid without a last name" do
    @person.last_name = nil
    @person.should be_invalid    
  end
  
  it "is not valid with a gender set to anything other than 'M' or 'F'" do
    @person.gender = 'foo'
    @person.should be_invalid
  end
  
  it "is valid with gender set to 'M'" do
    @person.gender = 'M'
    @person.should be_valid
  end
  
  it "is valid with gender set to 'F'" do
    @person.gender = 'F'
    @person.should be_valid
  end
  
  it "is valid with nil gender" do
    @person.gender = nil
    @person.should be_valid
  end
  
  it "is not valid with graduation year set to a non-integer" do
    @person.graduation_year = 'foo'
    @person.should be_invalid
  end
  
  it "is not valid with graduation year with other than four digits" do
    @person.graduation_year = 10000
    @person.should be_invalid
  end
  
  it "is valid with nil graduation year" do
    @person.graduation_year = nil
    @person.should be_valid
  end
  
end
