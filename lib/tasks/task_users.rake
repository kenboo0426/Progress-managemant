require './lib/task_helper'
require 'net/https'
require 'uri'
require 'json'
require "open-uri"
require 'date'
include TaskHelper

namespace :task_users do
  desc "ユーザー作成"
  task :new_users => :environment do
    logger = Logger.new 'log/users.log'
    logger.debug("test")
    file_name = File.basename(__FILE__)
    begin
      get_users = call_api(users())
      get_users.each do |u|
        User.create(user_id: u[:id],name: u[:lastname] + u[:firstname])
      end
      # SlackNotifier.success(file_name: file_name)
    rescue => exception
      SlackNotifier.error(file_name: file_name, detail: exception)
    end
  end
end
