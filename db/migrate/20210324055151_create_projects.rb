class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.integer :project_id
      t.integer :parent_id
      t.string :project_name
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
