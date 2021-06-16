class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.integer :issue_id
      t.string :issue_name
      t.string :status
      t.float :estimate_hours
      t.float :spent_hours

      t.timestamps
    end
  end
end
