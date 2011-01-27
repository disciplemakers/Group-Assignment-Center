class AddCommentToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :comment, :text
  end

  def self.down
    remove_column :locations, :comment
  end
end
