# @see OrchestratorNsCatalogue
class OrchestratorNsCatalogue < Sinatra::Application
	get '/health' do
		status 200
		return "Ok"
	end
	
end
