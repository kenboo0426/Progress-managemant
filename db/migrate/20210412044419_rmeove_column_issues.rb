class RmeoveColumnIssues < ActiveRecord::Migration[6.1]
  def change
    remove_column :issues, :status, :integer
    remove_column :issues, :estimate_hours, :float
    remove_column :issues, :spent_hours, :float
    remove_column :issues, :start_date, :date
    remove_column :issues, :created_on, :date
    remove_column :issues, :closed_on, :date
  end
end
