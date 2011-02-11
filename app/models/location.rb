class Location < ActiveRecord::Base
  belongs_to :parent, :class_name => "Location", :foreign_key => "parent_id"
  has_many :children, :class_name => "Location", 
           :foreign_key => "parent_id", :dependent => :destroy
  has_many :groups
  has_many :events
end
