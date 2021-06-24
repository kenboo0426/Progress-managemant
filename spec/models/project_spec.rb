require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "バリデーション" do
    it "project_idとupdatedが一意でなければ、無効" do
      date = Date.current
      Project.create(project_id: 0, updated: date)
      project = Project.new(project_id: 0, updated: date)
      expect(project).not_to be_valid
    end
    
  end
end
