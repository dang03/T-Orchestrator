root = ::File.dirname(__FILE__)
require ::File.join(root, 'main')
require 'sinatra/auth'
run OrchestratorNsdValidator.new
