class Assignment < ActiveRecord::Base
  belongs_to :group
  belongs_to :person
  
  validates :group_id, :person_id, :presence => true
  validate :assignments_must_not_exceed_group_capacity
  validate :assignments_cannot_be_made_to_non_people_groups
  validate :unique_membership
  
  def assignments_must_not_exceed_group_capacity
    group = self.group
    return if group.capacity.nil?
    person = self.person
    errors.add(:base, "Error assigning #{person.full_name}: #{group.name} is at full capacity.\n") if group.people.count >= group.capacity
  end
  
  def assignments_cannot_be_made_to_non_people_groups
    group = self.group
    return if group.can_contain_people
    person = self.person
    errors.add(:base, "Error assigning #{person.full_name}: #{group.name} is not marked as able to contain people.\n")
  end
  
  def unique_membership
    group = self.group
    
    constrained_group = group.unique_membership_scope 
    return unless constrained_group.name
    
    person.groups.each do |g|
      if g.is_descendant_of?(constrained_group)
        errors.add(:base, "Error assigning #{person.full_name}: He/she is already assigned under #{constrained_group.name}.\n")
      end
    end
  end
end
