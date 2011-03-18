class Group < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :gender_constraint
  belongs_to :custom_field, :foreign_key => "label_field"
  belongs_to :location
  has_one :event
  has_many :assignments, :dependent => :destroy
  has_many :people, :through => :assignments, :order => "people.last_name, people.first_name"
  
  validates_presence_of :name
  validates_numericality_of :capacity, :only_integer => true,
                            :allow_nil => true,
                            :greater_than_or_equal_to => 0
  
  validate :parent_can_contain_children
  
  def parent_can_contain_children
    if parent_id
      parent = Group.find(parent_id)
      unless parent.can_contain_groups
        errors.add_to_base("can not add group to a group that can not contain groups")
      end      
    end
  end
end
