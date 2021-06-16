class AddColumnPlannedCostSalesToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :planned_cost, :float
    add_column :projects, :sales, :float
    remove_column :costs, :planned_cost
    remove_column :costs, :sales
  end
end
