class Location < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :groups
  has_many :events
  
  before_destroy :clear_location_data
  
  def clear_location_data
    if self.root?
      # nullify event location fields
      if events = Event.find(:all, :conditions => {:location_id => self.id})
        events.each do |event|
          event.update_attribute("location_id", nil)
        end
      end
    end
    
    # nullify group location fields
    if groups = Group.find(:all, :conditions => {:location_id => self.id})
      groups.each do |group|
        group.update_attribute("location_id", nil)
      end
    end
  end
end
