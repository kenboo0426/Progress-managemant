class AddColumnProjectAndTimeENtry < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :planned_cost, :integer
    add_column :projects, :sales, :integer
    add_column :time_entries, :user_id, :integer
  end
end
