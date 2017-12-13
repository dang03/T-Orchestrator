ENV['RACK_ENV'] ||= 'development'

require 'sinatra'
require "sinatra/activerecord"
require 'json'
require 'net/http'
require 'eventmachine'
require 'rest-client'
require 'sinatra/config_file'

require_relative './models/serviceModel'
require_relative 'routes/init'
require_relative 'helpers/init'

class TnovaManager < Sinatra::Application
	enable :sessions
	set :port, 4000
	set :server, "thin"
	set :pool, 10
		configure do
		set :logging, true
		set :root, File.dirname(__FILE__)
		set :threaded, true
	end
		configure :development, :production do
		# console log to file
		log_path = "#{root}/log" 
		Dir.mkdir(log_path) unless File.exist?(log_path)
		log_file = File.new("#{log_path}/#{settings.environment}.log", "a+")
		#log_file.sync = true
		#$stdout.reopen(log_file)
		#$stderr.reopen(log_file)
				set :haml, { :ugly=>true }
		set :clean_trace, true
		enable :logging
	end

register Sinatra::ConfigFile
	# Load configurations
	config_file 'config/config.yml'
	helpers do
		include Rack::Utils
		alias_method :h, :escape_html
	end
	
	#microservice hashmap
	set :services, []
	
end

END{
	ServiceModel.delete_all
}