class AddColumnLatestUpdateToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :latest_update, :date
  end
end
