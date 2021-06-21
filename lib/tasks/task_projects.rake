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
    logger = Logger.new 'log/projects.log'
    logger.debug("test")
    file_name = File.basename(__FILE__)
    begin
      get_projects = call_api(projects())
      flag = 0
      get_projects.each do |p|
        parent_id = p[:parent][:id] if p[:parent].present?
        #idが237が来てから次に親がいないプロジェクトが来るまでnewしない（つまり、LaplaceHideの子プロジェクトをnewしない）
        if flag == 1 && !p[:parent].present?
          flag = 0
        end
        flag = 1 if p[:id] == 237
        if flag == 0
          Project.create(project_id: p[:id],parent_id: parent_id,project_name: p[:name],description: p[:description],status: p[:status],created: p[:created_on],updated: p[:updated_on],identifier: p[:identifier])
        end
      end
      # SlackNotifier.success(file_name: file_name)
    rescue => exception
      SlackNotifier.error(file_name: file_name, detail: exception)
    end

  end
end
