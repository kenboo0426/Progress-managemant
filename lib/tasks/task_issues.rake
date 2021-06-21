require './lib/task_helper'
require 'net/https'
require 'uri'
require 'json'
require "open-uri"
require 'date'
include TaskHelper

namespace :task_issues do
  desc "イシュー作成"
  task :new_issues => :environment do
    logger = Logger.new 'log/issues.log'
    logger.debug("test")
    file_name = File.basename(__FILE__)
    begin
      all_project = Project.all
      all_project.each do |project|
        last_acquisition = project.issues.compact.max {|a, b| a.updated_at <=> b.updated_at}
        query = last_acquisition ? URI.encode_www_form(updated_on: last_acquisition.updated_at.iso8601) : ""
  
        get_issues = call_api(issues(query, project.project_id))
        get_issues.each do |p|
          issue = Issue.find_by(issue_id: p[:id])
          if issue && issue.updated != p[:updated_on]
            issue.update(issue_name: p[:subject],updated: p[:updated_on],estimate_hours: p[:estimated_hours],closed_on: p[:closed_on])
            p[:start_date].present? ? issue.update(start_date: p[:start_date]) : issue.update(start_date: p[:created_on])
          elsif !issue
            new_issue = Issue.new(project_id: p[:project][:id],issue_id: p[:id],issue_name: p[:subject],updated: p[:updated_on],estimate_hours: p[:estimated_hours],closed_on: p[:closed_on])
            p[:start_date].present? ? new_issue.update(start_date: p[:start_date]).save : new_issue.update(start_date: p[:created_on]).save
          end
        end
      end
      # SlackNotifier.success(file_name: file_name)
    rescue => exception
      SlackNotifier.error(file_name: file_name, detail: exception)
    end

  end
end
