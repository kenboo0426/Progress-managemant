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
        last_acquisition = Time.now
        if LastAcquisition.find_by(project_id: project.project_id)
          project = LastAcquisition.find_by(project_id: project.project_id)
          @query = URI.encode_www_form(updated_on: "#{project.last_acquisition.iso8601}")
          LastAcquisition.find_by(project_id: project.project_id).update(last_acquisition: last_acquisition)
        else
          @query = ""
          LastAcquisition.new(project_id: project.project_id,last_acquisition: last_acquisition).save
        end
  
        get_issues = call_api(issues(@query, project.project_id))
        get_issues.each do |p|
          if Issue.find_by(issue_id: p[:id]) && Issue.find_by(issue_id: p[:id]).updated != p[:updated_on]
            if p[:start_date].present?
              Issue.find_by(issue_id: p[:id]).update(issue_name: p[:subject],updated: p[:updated_on],estimate_hours: p[:estimated_hours],start_date: p[:start_date],closed_on: p[:closed_on])
            else
              Issue.find_by(issue_id: p[:id]).update(issue_name: p[:subject],updated: p[:updated_on],estimate_hours: p[:estimated_hours],start_date: p[:created_on],closed_on: p[:closed_on])
            end
          elsif !Issue.find_by(issue_id: p[:id])
            
            if p[:start_date].present?
              Issue.new(project_id: p[:project][:id],issue_id: p[:id],issue_name: p[:subject],updated: p[:updated_on],estimate_hours: p[:estimated_hours],start_date: p[:start_date],closed_on: p[:closed_on]).save
            else
              Issue.new(project_id: p[:project][:id],issue_id: p[:id],issue_name: p[:subject],updated: p[:updated_on],estimate_hours: p[:estimated_hours],start_date: p[:created_on],closed_on: p[:closed_on]).save
            end
          end
        end
      end
      # SlackNotifier.success(file_name: file_name)
    rescue => exception
      SlackNotifier.error(file_name: file_name, detail: exception)
    end

  end
end
