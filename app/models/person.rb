class Person < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :confirmation_number
  validates_numericality_of :confirmation_number, :only_integer => true
  validates_numericality_of :graduation_year, :only_integer => true, 
                                              :allow_blank => true,
                                              :greater_than => 1900,
                                              :less_than => 2999
  validate :gender_must_be_M_or_F
  
  belongs_to :event
  has_many :assignments, :dependent => :destroy
  has_many :groups, :through => :assignments
  
  # Returns an array of all People who are assigned to the given
  # group or one of its descendants.
  def self.find_all_assigned_under(group)
    self.all.select { |p| p.assigned_under?(group) }
  end
  
  # Returns true if the Person is assigned to the given group
  # or one of its descendants.
  def assigned_under?(group)
    !(self.groups & group.self_and_descendants).empty?
  end
  
  def gender_must_be_M_or_F
    errors.add(:gender, "must be 'M' or 'F'") unless
      gender == 'M' or gender == 'F' or gender.nil?
  end
  
  def self.sortable_fields
    sortable_fields = { 'School' => "School",
                        'Graduation Year' => "graduation_year",
                        'Gender' => "gender",
                        'Registration Type' => "registration_type",
                        'Name (Last, First)' => "last_name, first_name",
                        'Name (First, Last)first_name' => "first_name, last_name" }
  end
  
  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
  end
  
  def full_name_and_info
    schools = { 'Kutztown University'         => 'KU',
                'Lafayette College'           => 'LC',
                'Muhlenberg College'          => 'MC',
                'East Stroudsburg University' => 'ESU',
                'Penn State University'       => 'PSU',
                'Gettysburg College'          => 'GC',
                'Shippensburg University'     => 'Ship',
                'Bucknell University'         => 'Bucknell',
                'Bloomsburg University'       => 'Bloom' }
    
    ed_info = String.new
    if (!self.graduation_year.nil? or !self.school.nil?)
      ed_info += " ("
      ed_info += (schools[self.school].nil? ? self.school : schools[self.school]) unless self.school.nil? 
      ed_info += " " if !self.school.nil? and !self.graduation_year.nil?
      ed_info += "'#{self.graduation_year.to_i.modulo(100)}" if !self.graduation_year.nil?
      ed_info += ")"
    end
    
    # reg_type, gender, school, grad_year
    full_info = "#{self.full_name} - #{self.registration_type}#{ed_info}"
  end
end
