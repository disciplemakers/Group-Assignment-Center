class AddIndicesToGroupTable < ActiveRecord::Migration
  def self.up
    add_index :groups, [:id, :lft, :rgt], :unique => true
    add_index :groups, [:lft, :rgt], :unique => true
    add_index :groups, :parent_id
  end

  def self.down
    remove_index :groups, [:id, :lft, :rgt]
    remove_index :groups, [:lft, :rgt]
    remove_index :groups, :parent_id
  end
end
