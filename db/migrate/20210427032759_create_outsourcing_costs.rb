class CreateOutsourcingCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :outsourcing_costs do |t|
      t.integer :project_id
      t.float :cost
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
