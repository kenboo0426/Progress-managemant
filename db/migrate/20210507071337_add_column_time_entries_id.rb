class AddColumnTimeEntriesId < ActiveRecord::Migration[6.1]
  def change
    add_column :time_entries, :time_entry_id, :integer
  end
end
