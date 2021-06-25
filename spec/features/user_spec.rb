require 'rails_helper'

RSpec.feature "Users", type: :feature do
  describe "ユーザー" do
    it "編集" do
      User.create(user_id: 0, name: "hoge", salary: 1000)
      visit users_path
      click_on "編集"
      fill_in 'user_salary', with: 2000
      click_on "更新"
      user = User.find_by(user_id: 0)
      expect(user.salary).to eq 2000
    end

    it "削除" do
      User.create(user_id: 0, name: "hoge", salary: 1000)
      visit users_path
      click_on "削除"
      expect(page).not_to have_selector 'table', text: 'hoge'
    end
  end
end
