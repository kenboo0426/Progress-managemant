class AddColumnLeaderNameGradeToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :leader_name, :string
    add_column :projects, :grade, :string
  end
end
