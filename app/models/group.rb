class Group < ActiveRecord::Base
  belongs_to :gender_constraint
  belongs_to :location
  belongs_to :parent, :class_name => "Group", :foreign_key => "parent_id"
  has_many :children, :class_name => "Group", 
           :foreign_key => "parent_id", :dependent => :destroy
end
