class AddCapacityToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :capacity, :integer
  end

  def self.down
    remove_column :locations, :capacity
  end
end
