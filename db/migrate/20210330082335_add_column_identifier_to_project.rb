class AddColumnIdentifierToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :identifier, :string
  end
end
