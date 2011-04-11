class Group < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :gender_constraint
  belongs_to :custom_field, :foreign_key => "label_field"
  belongs_to :location
  has_one :event
  has_many :assignments, :dependent => :destroy
  has_many :people, :through => :assignments, :order => "people.last_name, people.first_name"
  
  validates_presence_of :name
  #validates_presence_of :label_field, :unless => :label_text.blank?
  validates_numericality_of :capacity, :only_integer => true,
                            :allow_nil => true,
                            :greater_than_or_equal_to => 0                          
  
  validates_format_of :label_text,
                      :with => /^[^'"]*\z/,
                      :message => "Label text cannot contain single or double quotes."
  
  validate :parent_can_contain_children
  
  def parent_can_contain_children
    if parent_id
      parent = Group.find(parent_id)
      unless parent.can_contain_groups
        errors.add(:base, "Error adding group to #{parent.name}: This group not marked as able to contain groups.\n")
      end      
    end
  end
  
  # Returns the ancestor of the given group in which required_membership is set,
  # or itself if no ancestor has required_membership set.
  def required_membership_scope
    self.self_and_ancestors.reverse_each do |g|
      if g.required_membership
        return g
      end
    end
    return self
  end

  # Returns the ancestor of the given group in which unique_membership is set,
  # or itself if no ancestor has unique_membership set.
  def unique_membership_scope
    self.self_and_ancestors.reverse_each do |g|
      if g.unique_membership
        return g
      end
    end
    return self
  end
  
  def build_custom_field_text
    return '' if self.label_field.blank?
    text_array = []
    ancestry = self.self_and_ancestors
    ancestry.each do |g|
      text_array << g.label_text if ((g.label_field = self.label_field) and g.label_text_prepend_to_child_label) or (g == self)
    end
    text_array.compact
    text = text_array.join(" ")
  end
end
