class AddColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :updated, :date
    remove_column :projects, :update, :date
  end
end
