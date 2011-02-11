class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :remote_event_id
      t.integer :remote_report_id
      t.integer :location_id
      t.integer :group_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
