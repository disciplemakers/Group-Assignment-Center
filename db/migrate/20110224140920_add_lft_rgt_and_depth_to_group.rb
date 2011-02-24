class AddLftRgtAndDepthToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :lft, :integer
    add_column :groups, :rgt, :integer
    add_column :groups, :depth, :integer
  end

  def self.down
    remove_column :groups, :depth
    remove_column :groups, :rgt
    remove_column :groups, :lft
  end
end
