require 'rails_helper'

RSpec.feature "Relations", type: :feature do
  let(:date) { Date.current }
  let(:project) { Project.new(project_id: 0, updated: date, created: date, updated: date) }
  let(:user) { User.new(user_id: 0, name: "hoge", salary: 1000)}
  let(:relationships) { Relationship.new(project_id: 0, user_id: 0, roles: "管理者") }
  
  describe "リレーション" do
    it "ユーザー表示できているか" do
      project.save
      user.save
      relationships.save
      visit users_project_path(0)
      expect(page).to have_link 'hoge'
    end
  end
end
