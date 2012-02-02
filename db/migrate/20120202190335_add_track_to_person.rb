class AddTrackToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :track, :string
  end

  def self.down
    remove_column :people, :track
  end
end
