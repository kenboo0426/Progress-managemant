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
      if LastAcquisition.order(:last_acquisition).last
        project = LastAcquisition.order(:last_acquisition).last
        @from = "from=#{project.last_acquisition.to_date}&"
      else
        @from = ""
      end
      all_project = Project.all
      all_project.each do |project|
        get_timeEntry = call_api(time_entries(@from, project.project_id))
        get_timeEntry.each do |p|
          if p[:hours] > 0.0
            if p[:issue].present?
              TimeEntry.new(time_entry_id: p[:id], issue_id: p[:issue][:id],hours: p[:hours],spent_on: p[:spent_on],activity_name: p[:activity][:name],user_id: p[:user][:id]).save
              @issue_id = p[:issue][:id]
            else
              TimeEntry.new(time_entry_id: p[:id], issue_id: @issue_id,hours: p[:hours],spent_on: p[:spent_on],activity_name: p[:activity][:name],user_id: p[:user][:id]).save
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
