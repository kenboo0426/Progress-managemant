class RenameTableCostToLastAcquition < ActiveRecord::Migration[6.1]
  def change
    rename_table :costs, :last_acquisitions
  end
end
