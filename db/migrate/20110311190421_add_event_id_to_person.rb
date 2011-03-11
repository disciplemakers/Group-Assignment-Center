class AddEventIdToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :event_id, :integer
  end

  def self.down
    remove_column :people, :event_id
  end
end
