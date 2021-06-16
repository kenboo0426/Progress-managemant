class AddColumnProjectIdToVersion < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :project_id, :integer
  end
end
