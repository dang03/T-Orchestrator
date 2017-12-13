# @see OrchestratorVnfCatalogue
class OrchestratorVnfCatalogue < Sinatra::Application

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
	
	# @method post_vnfs
	# @overload post '/vnfs'
	# 	Post a VNF in JSON format
	# 	@param [JSON] VNF in JSON format
	# Post a VNF
	post '/vnfs' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		vnf, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		# Validate VNF
		# TODO: Maybe this should go into the VNFD Validator
		return 400, 'ERROR: VNF Name not found' unless vnf.has_key?('name')
		return 400, 'ERROR: VNFD not found' unless vnf.has_key?('vnfd')

		# Validate VNFD
		begin
			RestClient.post settings.vnfd_validator + '/vnfds', vnf['vnfd'].to_json, 'X-Auth-Token' => @client_token, :content_type => :json
		rescue => e
			if e.response == nil
				return 500, 'VNFD Validator unreachable'
			end
			logger.error e.response
			return e.response.code, e.response.body
		end

		# Save to BD
		begin
			new_vnf = Vnf.create!(vnf)
		rescue Moped::Errors::OperationFailure => e
			return 400, 'ERROR: Duplicated VNF ID' if e.message.include? 'E11000'
			return 400, e.message
		end

		return 200, new_vnf.to_json
	end

	# @method get_vnfs
	# @overload get '/vnfs'
	#	Returns a list of VNFs
	# List all VNFs
	get '/vnfs' do
		params[:offset] ||= 1
		params[:limit] ||= 2

		# Only accept positive numbers
		params[:offset] = 1 if params[:offset].to_i < 1
		params[:limit] = 2 if params[:limit].to_i < 1

		# Get paginated list
		vnfs = Vnf.paginate(:page => params[:offset], :limit => params[:limit])

		# Build HTTP Link Header
		headers['Link'] = build_http_link(params[:offset].to_i, params[:limit])

		return 200, vnfs.to_json
	end

	# @method get_vnfs_external_vnf_id
	# @overload get '/vnfs/:external_vnf_id'
	#	Show a VNF
	#	@param [Integer] external_vnf_id VNF external ID
	# Show a VNF
	get '/vnfs/:external_vnf_id' do
		begin
			vnf = Vnf.find(params[:external_vnf_id].to_i)
		rescue Mongoid::Errors::DocumentNotFound => e
			return 404
		end

		return 200, vnf.to_json
	end

	# @method delete_vnfs_external_vnf_id
	# @overload delete '/vnfs/:external_vnf_id'
	#	Delete a VNF by its ID
	#	@param [Integer] external_vnf_id VNF external ID
	# Delete a VNF
	delete '/vnfs/:external_vnf_id' do
		begin
			vnf = Vnf.find(params[:external_vnf_id].to_i)
		rescue Mongoid::Errors::DocumentNotFound => e
			return 404
		end

		vnf.destroy

		return 200
	end

	# @method put_vnfs_external_vnf_id
	# @overload put '/vnfs/:external_vnf_id'
	#	Update a VNF by its external ID
	#	@param [Integer] external_vnf_id VNF external ID
	# Update a VNF
	put '/vnfs/:external_vnf_id' do
		return 501, 'Not implemented yet'

		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		new_vnf, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		# Validate VNFD
#		begin
#			RestClient.post settings.vnfd_validator + '/vnfds', vnf['vnfd'].to_json, :content_type => :json
#		rescue => e
#			logger.error e.response
#			return e.response.code, e.response.body
#		end

		return 200
	end
end