class TimeEntry < ApplicationRecord
  belongs_to :issue, primary_key: :issue_id, foreign_key: :issue_id, optional: true
  belongs_to :user, primary_key: :user_id, foreign_key: :user_id, optional: true
  validates :time_entry_id, uniqueness: true
end
