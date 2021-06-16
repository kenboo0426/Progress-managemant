class CreateVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :versions do |t|
      t.string :name
      t.string :description
      t.date :due_date

      t.timestamps
    end
  end
end
