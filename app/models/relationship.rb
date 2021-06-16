class Relationship < ApplicationRecord
  belongs_to :project, primary_key: :project_id, foreign_key: :project_id
  belongs_to :user, primary_key: :user_id, foreign_key: :user_id
  validates :project_id, uniqueness: {scope: [:user_id]}
end
