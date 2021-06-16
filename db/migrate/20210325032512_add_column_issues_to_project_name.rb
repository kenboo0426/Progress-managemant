class AddColumnIssuesToProjectName < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :project_name, :string
  end
end
