class AddRemoteEventIdToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :remote_event_id, :integer
  end

  def self.down
    remove_column :groups, :remote_event_id
  end
end
