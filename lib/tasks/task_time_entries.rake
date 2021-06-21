require './lib/task_helper'
require 'net/https'
require 'uri'
require 'json'
require "open-uri"
require 'date'
include TaskHelper

namespace :task_time_entries do
  desc "作業時間記録"
  task :new_time_entries => :environment do
    logger = Logger.new 'log/time_entries.log'
    logger.debug("test")
    file_name = File.basename(__FILE__)
    begin
      all_project = Project.all
      all_project.each do |project|
        latest_time_entries_every_issue = project.issues.map { |issue| issue.time_entries.order("time_entries.updated_at desc").first }
        last_acquisition = latest_time_entries_every_issue.compact.max {|a, b| a.updated_at <=> b.updated_at}
        from = last_acquisition ? "from=#{last_acquisition.updated_at.to_date}&" : ""

        get_timeEntry = call_api(time_entries(from, project.project_id))
        get_timeEntry.each do |p|
          if p[:hours] > 0.0
            new_time_entry = TimeEntry.new(time_entry_id: p[:id], hours: p[:hours],spent_on: p[:spent_on],activity_name: p[:activity][:name],user_id: p[:user][:id])
            if p[:issue].present?
              new_time_entry.issue_id = p[:issue][:id]
              new_time_entry.save
              @issue_id = p[:issue][:id]
            else
              new_time_entry.issue_id = @issue_id
              new_time_entry.save
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
