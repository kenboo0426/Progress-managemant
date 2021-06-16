class Version < ApplicationRecord
  belongs_to :project, primary_key: :project_id, foreign_key: :project_id, optional: true
  validates :version_id, uniqueness: true
end
