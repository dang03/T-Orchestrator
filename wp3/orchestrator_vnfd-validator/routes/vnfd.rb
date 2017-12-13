# @see OrchestratorVnfdValidator
class OrchestratorVnfdValidator < Sinatra::Application

	before do
		pass if request.path_info == '/'
		# Validate every request with Gatekeeper
		@client_token = request.env['HTTP_X_AUTH_TOKEN']
		begin
			response = RestClient.get "#{settings.gatekeeper}/token/validate/#{@client_token}", 'X-Auth-Service-Key' => settings.service_key, :content_type => :json
		rescue => e
			logger.error e.response
			halt e.response.code, e.response.body
		end
	end

	# @method get_root
	# @overload get '/'
	#       Get all available interfaces
	# Get all interfaces
    get '/' do
    	return 200, interfaces_list.to_json
    end
	
	# @method post_vnfds
	# @note You have to specify the correct Content-Type
	# @overload post '/vnfds'
	# 	Post a VNFD in JSON format
	# 	@param [JSON]
	# 	@example Header for JSON
	# 		Content-Type: application/json
	# @overload post '/vnfds'
	# 	Post a VNFD in XML format
	# 	@param [XML]
	# 	@example Header for XML
	# 		Content-Type: application/xml
	#
	# Post a VNFD
	post '/vnfds' do
		# Read body content-type
		content_type = request.content_type
		body = request.body.read
		logger.debug "Content-Type: #{content_type}"

		# Return if content-type is invalid
		return 415 unless ( (content_type == 'application/json') or (content_type == 'application/xml') )

		# If message in JSON format
		if content_type == 'application/json'
			# Check if message is a valid JSON
			vnfd, errors = parse_json(body)
			return 400, errors if errors

			# Check if message is a valid VNFD
			vnfd, errors = validate_json_vnfd(vnfd)
			return 400, errors if errors
		end

		# Parse XML format
		if content_type == 'application/xml'
			# Check if message is a valid XML
			vnfd, errors = parse_xml(request.body.read)
			return 400, errors.to_json if errors

			# Check if message is a valid VNFD
			vnfd, errors = validate_xml_vnfd(vnfd)
			return 400, errors if errors
		end

		return 200
	end
end
