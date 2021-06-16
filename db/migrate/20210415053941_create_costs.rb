class CreateCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :costs do |t|
      t.integer :project_id
      t.datetime :last_acquisition

      t.timestamps
    end
  end
end
