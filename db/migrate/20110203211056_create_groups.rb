class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.integer :capacity
      t.boolean :can_contain_people
      t.boolean :can_contain_groups
      t.integer :location_id
      t.text :comment
      t.boolean :unique_membership
      t.boolean :required_membership
      t.integer :gender_constraint_id
      t.string :label_text
      t.boolean :label_text_prepend_to_child_label
      t.integer :label_field

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
