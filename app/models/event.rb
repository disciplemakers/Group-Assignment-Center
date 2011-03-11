class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :status
  belongs_to :group, :dependent => :destroy
  has_many :people, :dependent => :destroy
end
