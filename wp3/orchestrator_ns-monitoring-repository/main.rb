# Set environment
env = ENV['RACK_ENV'] ||= 'development'

require 'sinatra'
require 'sinatra/config_file'
require 'yaml'
require 'cassandra-cql'

# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require_relative 'routes/init'
require_relative 'helpers/init'

configure do
	# Configure logging
	enable :logging
	log_file = File.new("#{settings.root}/log/#{settings.environment}.log", "a+")
	log_file.sync = true
	use Rack::CommonLogger, log_file

end

before do
	logger.level = Logger::DEBUG
	BASEDIR = File.join(File.dirname(__FILE__), '.')
	cassandra_config_file = File.join(BASEDIR, 'config', 'database.yml')
	cassandra_config = YAML::load_file(cassandra_config_file)[env]
	@db = CassandraCQL::Database.new("#{cassandra_config['host']}:9160")
	@db.execute("USE #{cassandra_config['keyspace']}")
end

class OrchestratorNsMonitoring < Sinatra::Application
	register Sinatra::ConfigFile
	# Load configurations
	config_file 'config/config.yml'

end

