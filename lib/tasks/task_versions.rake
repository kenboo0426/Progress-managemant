require './lib/task_helper'
require 'net/https'
require 'uri'
require 'json'
require "open-uri"
require 'date'
include TaskHelper

namespace :task_versions do
  desc "バージョン作成"
  task :new_versions => :environment do
    logger = Logger.new 'log/versions.log'
    logger.debug("test")
    file_name = File.basename(__FILE__)
    begin
      all_project = Project.all
      all_project.each do |project|
        versions = call_api(versions(project))
        versions.each do |version|
          if version[:due_date].present?
            Version.new(version_id: version[:id], project_id: version[:project][:id], name: version[:name], description: version[:description], due_date: version[:due_date]).save
          else
            Version.new(version_id: version[:id], project_id: version[:project][:id], name: version[:name], description: version[:description]).save
          end
        end
      end 
      # SlackNotifier.success(file_name: file_name)
    rescue => exception
      SlackNotifier.error(file_name: file_name, detail: exception)
    end
  end
end
