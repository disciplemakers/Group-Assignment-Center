class RemoveLftRgtIndexFromGroupTable < ActiveRecord::Migration
  def self.up
    remove_index :groups, [:lft, :rgt]
  end

  def self.down
  end
end
