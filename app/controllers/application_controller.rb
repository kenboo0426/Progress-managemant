class ApplicationController < ActionController::Base
  include RedmineHelper
  
  require 'net/https'
  require 'uri'
  require 'json'
  require "open-uri"
  require 'date'

end
