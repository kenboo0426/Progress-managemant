class CreateTimeEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :time_entries do |t|
      t.integer :issue_id
      t.float :hours
      t.date :spent_on
      t.string :activity_name

      t.timestamps
    end
  end
end
