class CreateGenderConstraints < ActiveRecord::Migration
  def self.up
    create_table :gender_constraints do |t|
      t.string :constraint

      t.timestamps
    end
  end

  def self.down
    drop_table :gender_constraints
  end
end
