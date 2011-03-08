class AddStatusIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :status_id, :integer
  end

  def self.down
    remove_column :events, :status_id
  end
end
