class AddColumnUpdatedToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :created, :date
    add_column :projects, :update, :date
    remove_column :projects, :created_on, :date
    remove_column :projects, :updated_on, :date
  end
end
