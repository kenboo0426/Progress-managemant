class JoinTableToIssue < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :estimate_hours, :float
    add_column :issues, :start_date, :date
    add_column :issues, :closed_on, :date
    remove_column :issues, :project_name, :string
  end
end
