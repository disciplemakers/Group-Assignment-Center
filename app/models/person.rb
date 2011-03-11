class Person < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  validates_numericality_of :confirmation_number, :only_integer => true
  validates_numericality_of :graduation_year, :only_integer => true, :allow_blank => true
  validates_length_of :graduation_year, :is => 4, :allow_blank => true
  validate :gender_must_be_M_or_F
  
  belongs_to :event
  has_many :assignments, :dependent => :destroy
  
  def gender_must_be_M_or_F
    errors.add(:gender, "must be 'M' or 'F'") unless
      gender == 'M' or gender == 'F' or gender.nil?
  end
  
  def full_name
    full_name = "#{self.first_name} #{self.last_name}"
  end
  
end
