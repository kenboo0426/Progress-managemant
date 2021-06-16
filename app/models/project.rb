class Project < ApplicationRecord
  self.primary_key = :project_id
  has_many :issues, dependent: :destroy
  has_many :users, primary_key: :project_id, foreign_key: :project_id, through: :relationships
  has_one :last_acquisition, dependent: :destroy
  has_many :outsourcing_costs, primary_key: :project_id, foreign_key: :project_id
  has_many :versions, primary_key: :project_id, foreign_key: :project_id, dependent: :destroy
  validates :project_id, uniqueness: {scope: [:updated]}
end
