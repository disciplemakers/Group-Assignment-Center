class AddIndicesToAllTables < ActiveRecord::Migration
  def self.up
    add_index :assignments, :id, :unique => true
    add_index :assignments, :group_id
    add_index :assignments, :person_id
    add_index :assignments, [:group_id, :person_id], :unique => true
    add_index :custom_fields, :id, :unique => true
    add_index :custom_fields, :name
    add_index :custom_fields, :people_field
    add_index :events, :id, :unique => true
    add_index :events, :remote_event_id, :unique => true
    add_index :events, :group_id, :unique => true
    add_index :events, :location_id
    add_index :events, :status_id
    add_index :gender_constraints, :id, :unique => true
    add_index :groups, :id, :unique => true
    add_index :groups, [:name, :remote_event_id], :unique => true
    add_index :groups, :location_id
    add_index :groups, :remote_event_id
    add_index :locations, :id, :unique => true
    add_index :locations, :name
    add_index :people, :id, :unique => true
    add_index :people, :confirmation_number, :unique => true
    add_index :people, :event_id
    add_index :statuses, :id, :unique => true
  end

  def self.down
    remove_index :assignments, :id
    remove_index :assignments, :group_id
    remove_index :assignments, :person_id
    remove_index :assignments, [:group_id, :person_id]
    remove_index :custom_fields, :id
    remove_index :custom_fields, :name
    remove_index :custom_fields, :people_field
    remove_index :events, :id
    remove_index :events, :remote_event_id
    remove_index :events, :group_id
    remove_index :events, :location_id
    remove_index :events, :status_id
    remove_index :gender_constraints, :id
    remove_index :groups, :id
    remove_index :groups, [:name, :remote_event_id]
    remove_index :groups, :location_id
    remove_index :groups, :remote_event_id
    remove_index :locations, :id
    remove_index :locations, :name
    remove_index :people, :id
    remove_index :people, :confirmation_number
    remove_index :people, :event_id
    remove_index :statuses, :id
  end
end
