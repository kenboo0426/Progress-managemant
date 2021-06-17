class ApplicationController < ActionController::Base
  include ProjectsHelper
  
  require 'net/https'
  require 'uri'
  require 'json'
  require "open-uri"
  require 'date'

end
