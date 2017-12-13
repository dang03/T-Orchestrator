# @see OrchestratorVnfManager
class OrchestratorVnfManager < Sinatra::Application

	# Checks if a JSON message is valid
	#
	# @param [JSON] message some JSON message
	# @return [Hash, nil] if the parsed message is a valid JSON
	# @return [Hash, String] if the parsed message is an invalid JSON
	def parse_json(message)
		# Check JSON message format
		begin
			parsed_message = JSON.parse(message) # parse json message
		rescue JSON::ParserError => e
			# If JSON not valid, return with errors
			logger.error "JSON parsing: #{e.to_s}"
			return message, e.to_s + "\n"
		end

		return parsed_message, nil
	end

	# Method which lists all available interfaces
	#
	# @return [Array] the array containing a list of all interfaces
	def interfaces_list
		[
			{
				'uri' => '/',
				'method' => 'GET',
				'purpose' => 'REST API Structure and Capability Discovery'
			},
			{
				'uri' => '/vnfs',
				'method' => 'GET',
				'purpose' => 'List all VNFs'
			},
			{
				'uri' => '/vnfs/{external_vnf_id}',
				'method' => 'GET',
				'purpose' => 'List a specific VNF'
			},
			{
				'uri' => '/vnfs',
				'method' => 'POST',
				'purpose' => 'Store a new VNF'
			},
			{
				'uri' => '/vnfs/{external_vnf_id}',
				'method' => 'PUT',
				'purpose' => 'Update a stored VNF'
			},
			{
				'uri' => '/vnfs/{external_vnf_id}',
				'method' => 'DELETE',
				'purpose' => 'Delete a specific VNF'
			},
        	{
        		'uri' => '/vnf-instances',
        		'method' => 'POST',
        		'purpose' => 'Request the instantiation of a VNF'
        	},
        	{
        		'uri' => '/configs',
        		'method' => 'GET',
        		'purpose' => 'List all services configurations'
        	},
        	{
        		'uri' => '/configs/{config_id}',
        		'method' => 'GET',
        		'purpose' => 'List a specific service configuration'
        	},
        	{
        		'uri' => '/configs/{config_id}',
        		'method' => 'PUT',
        		'purpose' => 'Update a service configuration'
        	},
        	{
        		'uri' => '/configs/{config_id}',
        		'method' => 'PUT',
        		'purpose' => 'Update a service configuration'
        	},
        	{
        		'uri' => '/configs/{config_id}',
        		'method' => 'DELETE',
        		'purpose' => 'Delete a service configuration'
        	}
		]
	end
end