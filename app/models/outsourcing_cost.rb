class OutsourcingCost < ApplicationRecord
  belongs_to :projects, primary_key: :project_id, foreign_key: :project_id, optional: true
end
