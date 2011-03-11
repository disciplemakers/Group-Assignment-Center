class Group < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :gender_constraint
  belongs_to :location
  has_one :event
  has_many :assignments, :dependent => :destroy
  has_many :people, :through => :assignments
  
  validates_presence_of :name
  validates_numericality_of :capacity, :only_integer => true,
                            :allow_nil => true,
                            :greater_than_or_equal_to => 0
  
end
