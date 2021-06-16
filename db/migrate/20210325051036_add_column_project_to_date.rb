class AddColumnProjectToDate < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :created_on, :date
    add_column :projects, :updated_on, :date
  end
end
