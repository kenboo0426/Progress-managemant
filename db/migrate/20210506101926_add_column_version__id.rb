class AddColumnVersionId < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :version_id, :integer
  end
end
