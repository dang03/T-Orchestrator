# @see OrchestratorVnfProvisioning
class OrchestratorVnfProvisioning < Sinatra::Application
	
	# @method post_instantiate
    # @overload post '/vnf-provisioning/vnf-instances'
    #       Instantiate a VNF
    #       @param [JSON] vnf the VNF to instantiate
    # Instantiate a VNF
    post '/vnf-provisioning/vnf-instances' do
    	# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		instantiation_info, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		# GET information
		vnf = instantiation_info['vnf']
		tenant = instantiation_info['auth']['tenant']
		username = instantiation_info['auth']['username']
		user_password = instantiation_info['auth']['password']

		# GET auth token
		auth_hash = {auth: {tenantName: tenant, passwordCredentials: {username: username, password: user_password}}}
		begin
			response = RestClient.post settings.vim_identity_manager + '/tokens', auth_hash.to_json, :content_type => :json, :accept => :json
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end
		token_info = JSON.parse(response)
		auth_token = token_info['access']['token']['id']

		logger.debug 'auth_token: ' + auth_token.inspect

		begin
			response = RestClient.get settings.vim_orchestrator + '/stacks', 'X-Auth-Token' => auth_token, :accept => :json
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		logger.debug 'Stacks: ' + response

		return 200


		# Call HOT generator
		begin
			response = RestClient.post settings.hot_generator + '/hot', vnf, :content_type => :json, :accept => :json
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		return response.code, response.body
	end

end