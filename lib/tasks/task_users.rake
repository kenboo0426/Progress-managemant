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
    #ログ
    logger = Logger.new 'log/users.log'
    logger.debug("test")

    get_users = call_api(users())
      get_users.each do |u|
        User.new(user_id: u[:id],name: u[:lastname] + u[:firstname]).save
        p "User saved!"
      end
  end
end
