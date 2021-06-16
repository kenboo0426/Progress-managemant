class AddDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :show, :integer, default: 0
  end
end
