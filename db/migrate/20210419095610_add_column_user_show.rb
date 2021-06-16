class AddColumnUserShow < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :show, :integer
  end
end
