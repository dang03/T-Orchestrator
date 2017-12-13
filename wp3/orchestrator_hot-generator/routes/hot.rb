# @see OrchestratorHotGenerator
class OrchestratorHotGenerator < Sinatra::Application

	before do
		# Validate every request with Gatekeeper
		@client_token = request.env['HTTP_X_AUTH_TOKEN']
		begin
			response = RestClient.get "#{settings.gatekeeper}/token/validate/#{@client_token}", 'X-Auth-Service-Key' => settings.service_key, :content_type => :json
		rescue => e
			logger.error e.response
			halt e.response.code, e.response.body
		end
	end
	
	post '/hot' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		vnf, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		# Validate VNFD
#		begin
#			RestClient.post settings.vnfd_validator + '/vnfds', vnf['vnfd'].to_json, :content_type => :json, :accept => :json
#		rescue => e
#			logger.error e.response
#			return e.response.code, e.response.body
#		end

		# Build a HOT template
		hot = generate_hot_template(vnf['name'], vnf['vnfd'])

		# Save it to a file for testing purpose
		save_hot2file(hot)

		return 200
	end

end
