class Event < ActiveRecord::Base
  default_scope :order => "start_date DESC"
  belongs_to :location
  belongs_to :status
  belongs_to :group, :dependent => :destroy
  has_many :people, :dependent => :destroy, :order => "people.last_name, people.first_name"
end
