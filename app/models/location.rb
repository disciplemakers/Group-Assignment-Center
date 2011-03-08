class Location < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :groups
  has_many :events
  
end
