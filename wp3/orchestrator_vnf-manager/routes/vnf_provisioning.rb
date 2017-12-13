# @see OrchestratorVnfManager
class OrchestratorVnfManager < Sinatra::Application

        # @method vnf-instances
        # @overload post '/vnf-instances'
        #       Request the instantiation of a VNF
        #       @param [JSON] 
        # Request the instantiation of a VNF
        post '/vnf-instances' do
                # Return if content-type is invalid
                return 415 unless request.content_type == 'application/json'

                # Validate JSON format
                instantiation_info, errors = parse_json(request.body.read)
                return 400, errors.to_json if errors

                # Get VNF by id
                begin
                        vnf = RestClient.get settings.vnf_catalogue + '/vnfs/' + instantiation_info['vnf_instances']['id'].to_s, 'X-Auth-Token' => @client_token
                rescue => e
                        logger.error e.response
                        return e.response.code, e.response.body
                end

                provisioning = {vnf: vnf, auth: instantiation_info['vnf_instances']['user']}

                # Send provisioning info to VNF Provisioning
                begin
                        response = RestClient.post settings.vnf_provisioning + '/vnf-provisioning/vnf-instances', provisioning.to_json, 'X-Auth-Token' => @client_token, :content_type => :json
                rescue => e
                        logger.error e.response
                        return e.response.code, e.response.body
                end

                return 200, instantiation_info['vnf_instances']['id']
        end

end