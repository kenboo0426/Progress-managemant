require './lib/task_helper'
require 'net/https'
require 'uri'
require 'json'
require "open-uri"
require 'date'
include TaskHelper

namespace :task_users_project_has do
  desc "プロジェクトメンバー作成"
  task :new_users_project_has => :environment do
    #ログ
    logger = Logger.new 'log/users_project_has.log'
    logger.debug("test")
    
    all_project = Project.all
    all_project.each do |project|
      project_to_users = call_api(users_project_has(project.project_id))
      if project_to_users.present?
        project_to_users.each do |u|
          p "プロジェクトメンバー"
          if u[:user].present?
            Relationship.new(project_id: project.project_id, user_id: u[:user][:id], roles: u[:roles][0][:name]).save
            p "User have project saved!"
          elsif u[:group]
          end
        end
      end
    end
  end
end
