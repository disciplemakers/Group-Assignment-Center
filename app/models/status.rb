class Status < ActiveRecord::Base
  has_many :events
end
