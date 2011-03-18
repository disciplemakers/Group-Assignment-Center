class CreateCustomFields < ActiveRecord::Migration
  def self.up
    create_table :custom_fields do |t|
      t.string :name
      t.string :people_field

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_fields
  end
end
