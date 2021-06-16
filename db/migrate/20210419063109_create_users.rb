class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :name
      t.float :salary

      t.timestamps
    end
  end
end
