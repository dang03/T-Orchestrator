# @see OrchestratorVnfManager
class OrchestratorVnfManager < Sinatra::Application

	# @method put_configs_config_id
	# @overload put '/configs/:config_id'
	# 	Update a configuration value
	# 	@param [Integer]
	# Update a configuration
	put '/configs/:config_id' do
		return 501, 'Not implemented yet'

		return 400, 'Invalid service ID' unless ['vnf-catalogue', 'vnf-provisioning', 'vnf-monitoring', 'vnf-scaling'].include? params[:config_id]

		begin
			response = RestClient.put settins.ns_manager + 'configs/services', 'X-Auth-Token' => @client_token
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		return response.code, response.body
	end

	# @method get_configs
	# @overload get '/configs'
	# 	List all configurations
	# Get all configs
	get '/configs' do
		# Forward request to NS Manager
		begin
			response = RestClient.get settings.ns_manager + '/configs/services', 'X-Auth-Token' => @client_token
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		return response.code, response.body
	end

	# @method get_configs_config_id
	# @overload get '/configs/:config_id'
	# 	Show a specific configuration
	# 	@param [Integer]
	# Get a specific config
	get '/configs/:config_id' do
		# Forward request to NS Manager
		begin
			response = RestClient.get settings.ns_manager + '/configs/services', {params: {name: params[:config_id]}}, 'X-Auth-Token' => @client_token
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		return response.code, response.body
	end

	# @method delete_configs_config_id
	# @overload delete '/configs/:config_id'
	# 	Delete a specific configuration
	# 	@param [Integer]
	# Delete a configuration
	delete 'configs/:config_id' do
		# Forward request to NS Manager
		begin
			response = RestClient.delete settings.ns_manager + '/configs/services', {params: {name: params[:config_id]}}, 'X-Auth-Token' => @client_token
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		return response.code, response.body
	end

end