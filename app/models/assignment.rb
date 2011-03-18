class Assignment < ActiveRecord::Base
  belongs_to :group
  belongs_to :person
  
  validates :group_id, :person_id, :presence => true
  validate :assignments_must_not_exceed_group_capacity
  validate :assignments_cannot_be_made_to_group_only_groups
  validate :unique_membership
  
  def assignments_must_not_exceed_group_capacity
    group = self.group
    return if group.capacity.nil?
    errors.add_to_base("can not add new assignment to full group") if group.people.count >= group.capacity
  end
  
  def assignments_cannot_be_made_to_group_only_groups
    group = self.group
    return if group.can_contain_people
    errors.add_to_base("can not add person to a group that can only contain groups")
  end
  
  def unique_membership
    group = self.group
    ancestors = group.self_and_ancestors
    person = self.person
    
    constrained_group = Group.new
    ancestors.reverse_each do |g|
      if g.unique_membership
        constrained_group = g
        break
      end
    end

    return unless constrained_group.name
    
    person.groups.each do |g|
      if g.is_descendant_of?(constrained_group)
        errors.add_to_base("#{person.full_name} already assigned under #{constrained_group}")
      end
    end
  end
end
