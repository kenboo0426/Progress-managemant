require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:date) { Date.current }
  let(:project) { Project.create(project_id: 0, updated: date, created: date, updated: date) }
  let(:issue) { Issue.create(issue_id: 0, project_id: 0, updated: date) }
  let(:outsourcing_cost) { OutsourcingCost.create(project_id: 0, name: "hoge", cost: 100, description: "hogehoge") }
  let(:version) { Version.create(version_id: 0, project_id: 0, updated: date) }
  
  describe "フォーム操作" do
    it "受注額、予算、リーダー更新" do
      visit project_path(0)
      fill_in 'project_sales', with: "1000"
      fill_in 'project_planned_cost', with: "1000"
      fill_in 'project_leader_name', with: "hoge"
      find('.sales_form').click_on "更新"
      project = Project.find(0)
      expect(project.sales).to eq 1000
      expect(project.planned_cost).to eq 1000
      expect(project.leader_name).to eq "hoge"
    end

    it "外注費、名前、説明更新" do
      visit project_path(0)
      fill_in 'cost', with: "100"
      fill_in 'name', with: "hoge"
      fill_in 'description', with: "hogehoge"
      find('.outsource_form').click_on "更新"
      project = Project.find(0)
      expect(project.outsourcing_costs.first.cost).to eq 100
      expect(project.outsourcing_costs.first.name).to eq "hoge"
      expect(project.outsourcing_costs.first.description).to eq "hogehoge"
    end

    it "外注費、名前、説明削除" do
      outsourcing_cost
      visit project_path(0)
      find('.outsource_form').click_on "削除"
      project = Project.find(0)
      expect(project.outsourcing_costs.first).not_to be_present
    end
  end

  describe "バージョン qcチェック" do
    it "未確認" do
      Version.create(version_id: 0, project_id: 0,  qc_checked: false)
      visit project_path(0)
      project = Project.find(0)
      find('.version_form').click_on "未確認"
      expect(project.versions.first.qc_checked).to eq true
    end

    it "確認済み" do
      Version.create(version_id: 0, project_id: 0, qc_checked: true)
      visit project_path(0)
      project = Project.find(0)
      find('.version_form').click_on "確認済み"
      expect(project.versions.first.qc_checked).to eq false
    end
  end

  describe "Chert.js" do
    it "表示できてるか" do
      visit project_path(0)
      expect(page).to have_selector 'canvas#time'
      expect(page).to have_selector 'canvas#money'
    end
  end


end
