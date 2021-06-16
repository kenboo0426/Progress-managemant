class AddColumnSalesPlannedCostToCost < ActiveRecord::Migration[6.1]
  def change
    add_column :costs, :planned_cost, :integer
    add_column :costs, :sales, :integer
    remove_column :projects, :planned_cost
    remove_column :projects, :sales
  end
end
