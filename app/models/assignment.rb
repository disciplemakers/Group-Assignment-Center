class Assignment < ActiveRecord::Base
  belongs_to :group
  belongs_to :person
  
  validates :group_id, :person_id, :presence => true
  #validate :assignment_must_not_exceed_group_capacity, :unless => Group.find(group_id).capacity.nil?
  
  #def assignment_must_not_exceed_group_capacity
  #  group = Group.find(:group_id)
  #  puts "group.people = #{group.people}"
  #end
end
