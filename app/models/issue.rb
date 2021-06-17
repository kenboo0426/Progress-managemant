class Issue < ApplicationRecord
  belongs_to :project, primary_key: :project_id
  has_many :time_entries, primary_key: :issue_id, foreign_key: :issue_id, dependent: :destroy
  validates :issue_id, uniqueness: {scope: [:updated]}

  scope :done, -> { where("closed_on IS NOT NULL") }
  scope :not_done, -> { where("closed_on IS NULL") }
  scope :done_between_today_7days, -> { where("closed_on IS NULL").where(closed_on: Date.today - 7..Date.today) }
  scope :done_between_7days_14days, -> { where("closed_on IS NULL").where(closed_on: Date.today - 14..Date.today - 7) }
  scope :done_between_14days_21days, -> { where("closed_on IS NULL").where(closed_on: Date.today - 21..Date.today - 14) }
  scope :time_entries, -> { eager_load(:time_entries) }
  scope :time_entries_join_users, -> { eager_load(time_entries: :user).group("users.name") }
  scope :users_salary, -> { eager_load(time_entries: :user).group("users.salary") }
end
