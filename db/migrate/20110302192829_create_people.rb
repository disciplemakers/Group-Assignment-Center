class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :registration_type
      t.string :school
      t.string :graduation_year
      t.string :housing_assignment
      t.string :small_group_assignment
      t.string :campus_group_room

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
