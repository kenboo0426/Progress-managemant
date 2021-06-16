class AddColumnRolesToRelationship < ActiveRecord::Migration[6.1]
  def change
    add_column :relationships, :roles, :string
  end
end
