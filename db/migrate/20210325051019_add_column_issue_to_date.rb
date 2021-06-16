class AddColumnIssueToDate < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :start_date, :date
    add_column :issues, :created_on, :date
    add_column :issues, :updated_on, :date
    add_column :issues, :closed_on, :date
  end
end
