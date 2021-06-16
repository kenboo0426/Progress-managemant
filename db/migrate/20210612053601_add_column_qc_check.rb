class AddColumnQcCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :qc_checked, :boolean, default: false 
  end
end
