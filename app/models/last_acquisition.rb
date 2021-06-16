class LastAcquisition < ApplicationRecord
  belongs_to :project, primary_key: :project_id
end
