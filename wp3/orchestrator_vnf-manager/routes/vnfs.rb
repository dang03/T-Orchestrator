# @see OrchestratorVnfManager
class OrchestratorVnfManager < Sinatra::Application

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
	# 	@param [JSON]
	# Post a VNF
	post '/vnfs' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		vnf, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		# Forward request to VNF Catalogue
		begin
			response = RestClient.post settings.vnf_catalogue + request.fullpath, vnf.to_json, 'X-Auth-Token' => @client_token, :content_type => :json
		rescue => e
			logger.error e.response
			return e.response.code, e.response.body
		end

		return response.code, response.body
	end

        # @method put_vnfs_external_vnf_id
        # @overload put '/vnfs/:external_vnf_id'
        #       Update a VNF
        #       @param [Integer] external_vnf_id VNF external ID
        # Update a VNF
        put '/vnfs/:external_vnf_id' do
                # Return if content-type is invalid
                return 415 unless request.content_type == 'application/json'

                # Validate JSON format
                vnf, errors = parse_json(request.body.read)
                return 400, errors.to_json if errors

                # Forward request to VNF Catalogue
                begin
                        response = RestClient.put settings.vnf_catalogue + request.fullpath, vnf.to_json, 'X-Auth-Token' => @client_token, :content_type => :json
                rescue => e
                        logger.error e.response
                        return e.response.code, e.response.body
                end

                return response.code, response.body
        end

	# @method get_vnfs
        # @overload get '/vnfs'
        #       Returns a list of VNFs
        # List all VNFs
        get '/vnfs' do
		# Forward request to VNF Catalogue
                begin
                        response = RestClient.get settings.vnf_catalogue + request.fullpath, 'X-Auth-Token' => @client_token
                rescue => e
                        logger.error e.response
                        return e.response.code, e.response.body
                end

		# Forward response headers
		headers['Link'] = response.headers[:link]

                return response.code, response.body
        end

	# @method get_vnfs_external_vnf_id
        # @overload get '/vnfs/:external_vnf_id'
        #       Show a VNF
        #       @param [Integer] external_vnf_id VNF external ID
        # Show a VNF
        get '/vnfs/:external_vnf_id' do
		# Forward request to VNF Catalogue
                begin
                        response = RestClient.get settings.vnf_catalogue + request.fullpath, 'X-Auth-Token' => @client_token
                rescue => e
                        logger.error e.response
                        return e.response.code, e.response.body
                end

                return response.code, response.body
        end

        # @method delete_vnfs_external_vnf_id
        # @overload delete '/vnfs/:external_vnf_id'
        #       Delete a VNF by its external ID
        #       @param [Integer] external_vnf_id VNF external ID
        # Delete a VNF
        delete '/vnfs/:external_vnf_id' do
		# Forward request to VNF Catalogue
                begin
                        response = RestClient.delete settings.vnf_catalogue + request.fullpath, 'X-Auth-Token' => @client_token
                rescue => e
                        logger.error e.response
                        return e.response.code, e.response.body
                end

                return response.code, response.body
        end

end