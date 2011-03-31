require 'pp'

class GroupObserver < ActiveRecord::Observer
  def after_update(group)
    pp group.people
  end
end
