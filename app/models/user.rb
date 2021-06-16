class User < ApplicationRecord
  has_many :time_entries, primary_key: :user_id
  has_many :projects, primary_key: :user_id, foreign_key: :user_id, through: :relationships
  validates :user_id, uniqueness: true
end
