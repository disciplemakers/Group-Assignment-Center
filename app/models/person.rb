class Person < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  validates_numericality_of :graduation_year, :only_integer => true, :allow_nil => true
  validates_length_of :graduation_year, :is => 4, :allow_nil => true
  validate :gender_must_be_M_or_F
  
  def gender_must_be_M_or_F
    errors.add(:gender, "must be 'M' or 'F'") unless
      gender == 'M' or gender == 'F' or gender.nil?
  end
  
end
