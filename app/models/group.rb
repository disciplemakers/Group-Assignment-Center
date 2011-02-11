class Group < ActiveRecord::Base
  belongs_to :gender_constraint
  belongs_to :location
  belongs_to :parent, :class_name => "Group", :foreign_key => "parent_id"
  has_many :children, :class_name => "Group", 
           :foreign_key => "parent_id", :dependent => :destroy
  has_many :events
           
  after_initialize :normalize_unique_membership_constraint,
                   :normalize_required_membership_constraint,
                   :if => :has_valid_parent?
                   
  validates_presence_of :name
  validates_numericality_of :capacity, :only_integer => true,
                            :allow_nil => true,
                            :greater_than_or_equal_to => 0
  validates_inclusion_of :unique_membership, :required_membership,
                         :in => [true, false, nil]
  validate :unique_membership_with_respect_to_parent, :if => :has_valid_parent?
  validate :required_membership_with_respect_to_parent, :if => :has_valid_parent?
  
  def has_valid_parent?
    begin
      parent = Group.find(self.parent_id)
      true
    rescue
      false
    end
  end
  
  # Change the value of unique_membership to be consistent with parent
  # settings, if necessary.
  def normalize_unique_membership_constraint
    parent = Group.find(self.parent_id)
    unless self.unique_membership
      if parent.unique_membership != false
        self.unique_membership = nil 
      else
        self.unique_membership = false
      end
    end
  end
  
  def normalize_required_membership_constraint
    parent = Group.find(self.parent_id)
    unless self.required_membership
      if parent.required_membership.nil?
        self.required_membership = nil
      else
        self.required_membership = false
      end
    end
  end
                            
  def unique_membership_with_respect_to_parent
    parent = Group.find(self.parent_id)
    if parent.unique_membership == true or parent.unique_membership.nil?
      unless self.unique_membership.nil?
        errors.add(:unique_membership,
                   "can't be set when parent's unique membership constraint is enabled or nil")
      end  
    elsif parent.unique_membership == false
      if self.unique_membership.nil?
        errors.add(:unique_membership,
                   "must be set when parent's unique membership constraint is disabled")
      end
    else
      errors.add(:unique_membership,
                 "disallowed value of unique membership; this shouldn't ever happen")
    end 
  end
  
  def required_membership_with_respect_to_parent
    parent = Group.find(self.parent_id)
    if !parent.required_membership.nil?
      unless self.required_membership == false
        errors.add(:required_membership,
                   "must be disabled when parent's required membership constraint is enabled")
      end  
    elsif parent.required_membership.nil?
      if self.required_membership == false
        errors.add(:required_membership,
                   "must be true or nil when parent's required membership constraint is nil")
      end
    else
      errors.add(:required_membership,
                 "disallowed value of required membership; this shouldn't ever happen")
    end 
    
  end
end
