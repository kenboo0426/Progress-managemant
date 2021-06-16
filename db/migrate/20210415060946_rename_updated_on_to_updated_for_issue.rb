class RenameUpdatedOnToUpdatedForIssue < ActiveRecord::Migration[6.1]
  def change
    rename_column :issues, :updated_on, :updated
  end
end
