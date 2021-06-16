class ChangeColumnNullFalseToCost < ActiveRecord::Migration[6.1]
  def change
    change_column_null :outsourcing_costs, :cost, false
  end
end
