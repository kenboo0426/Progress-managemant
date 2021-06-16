class RemoveColumnLatestUpdate < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :latest_update, :date
  end
end
