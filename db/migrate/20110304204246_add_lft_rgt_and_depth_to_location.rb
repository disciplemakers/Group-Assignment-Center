class AddLftRgtAndDepthToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :lft, :integer
    add_column :locations, :rgt, :integer
    add_column :locations, :depth, :integer
  end

  def self.down
    remove_column :locations, :depth
    remove_column :locations, :rgt
    remove_column :locations, :lft
  end
end
