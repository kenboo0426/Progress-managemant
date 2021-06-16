require './lib/task_helper'
require 'net/https'
require 'uri'
require 'json'
require "open-uri"
require 'date'
include TaskHelper

namespace :task_projects do
  desc "プロジェクト作成"
  task :new_projects => :environment do
    #ログ
    logger = Logger.new 'log/projects.log'
    logger.debug("test")

    get_projects = call_api(projects())
    flag = 0
    get_projects.each do |p|
      if p[:parent].present?
        parent_id = p[:parent][:id]
      end
      #idが237が来てから次に親がいないプロジェクトが来るまでnewしない（つまり、LaplaceHideの子プロジェクトをnewしない）
      if flag == 1 && !p[:parent].present?
        flag = 0
      end
      flag = 1 if p[:id] == 237
      if flag == 0
        Project.new(project_id: p[:id],parent_id: parent_id,project_name: p[:name],description: p[:description],status: p[:status],created: p[:created_on],updated: p[:updated_on],identifier: p[:identifier]).save
        p "Project saved!"
      end
    end 
  end
end
