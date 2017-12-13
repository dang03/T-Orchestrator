# @see OrchestratorNsCatalogue
class OrchestratorNsCatalogue < Sinatra::Application

	# @method get_nss
	# @overload get '/network-services'
	#	Returns a list of NSs
	# List all NSs
	get '/network-services' do
		params[:offset] ||= 1
		params[:limit] ||= 2

		# Only accept positive numbers
		params[:offset] = 1 if params[:offset].to_i < 1
		params[:limit] = 2 if params[:limit].to_i < 1

		# Get paginated list
		nss = Ns.paginate(:page => params[:offset], :limit => params[:limit])
logger.error nss
		# Build HTTP Link Header
		headers['Link'] = build_http_link(params[:offset].to_i, params[:limit])

		return 200, nss.to_json
	end
		
	# @method get_nss_external_ns_id
	# @overload get '/network-services/:external_ns_id'
	#	Show a NS
	#	@param [Integer] external_ns_id NS external ID
	# Show a NS
	get '/network-services/:id' do
		begin
			logger.error params[:id]
			ns = Ns.find( params[:id])
		rescue Mongoid::Errors::DocumentNotFound => e
			logger.error e
			return 404
		end

		return 200, ns.to_json
	end
	
	# @method post_nss
	# @overload post '/network-services'
	# 	Post a NS in JSON format
	# 	@param [JSON] NS in JSON format
	# Post a NS
	post '/network-services' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		ns, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors
		
		logger.error ns
		
		# Validate NS
		# TODO: Maybe this should go into the NSD Validator
		#return 400, 'ERROR: NS Name not found' unless ns.has_key?('name')
		return 400, 'ERROR: NSD not found' unless ns.has_key?('nsd')

		# Validate NSD
		begin
			RestClient.post settings.nsd_validator + '/nsds', ns.to_json, :content_type => :json
		rescue => e
			if e.response == nil
				halt 500, {'Content-Type' => 'text/plain'}, "Validator mS unrechable."
			end
			halt 400, {'Content-Type' => 'text/plain'}, e.response
		end

		# Save to BD
		begin
			new_ns = Ns.create!(ns)
		rescue Moped::Errors::OperationFailure => e
			return 400, 'ERROR: Duplicated NS ID' if e.message.include? 'E11000'
			return 400, e.message
		end

		return 200, new_ns.to_json
	end
	
	## Catalogue - UPDATE
	put '/network-services/:id' do
		return 501, 'Not implemented yet'

		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		new_ns, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		# Validate VNFD
#		begin
#			RestClient.post settings.nsd_validator + '/nsds', ns['nsd'].to_json, :content_type => :json
#		rescue => e
#			logger.error e.response
#			return e.response.code, e.response.body
#		end

		return 200
	end
	
	# @method delete_vnfs_external_vnf_id
	# @overload delete '/vnfs/:external_vnf_id'
	#	Delete a VNF by its ID
	#	@param [Integer] external_vnf_id VNF external ID
	# Delete a VNF
	delete '/network-services/:id' do
		begin
			ns = Ns.find(params[:id].to_i)
		rescue Mongoid::Errors::DocumentNotFound => e
			return 404
		end
		ns.destroy
		return 200
	end
end
