class CreateLocationRelations < ActiveRecord::Migration
  def self.up
    create_table :location_relations do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
  end

  def self.down
    drop_table :location_relations
  end
end
