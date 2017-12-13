# @see OrchestratorNsProvisioner
class OrchestratorNsProvisioner < Sinatra::Application

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
	
	def getNSD(ns_id)
		#check if the request NS_id exist
		begin
			response = RestClient.get settings.ns_catalogue + '/network-services/' + ns_id, :accept => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "NS-Catalogue unavailable"
			end
			logger.error e.code
			halt e.response.code, e.response.body
		end
		
		nsd, errors = parse_json(response.body)
		return 400, errors if errors
		return nsd
	end

	def callMapping(ms)
			#make a request to the NS Mapping
		begin
			response = RestClient.post settings.ns_mapping + '/vnsd', ms.to_json, :content_type => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "NS-Mapping unavailable"
			end
			halt e.response.code, e.response.body
		end
		
		mapping, errors = parse_json(response.body)
		return 400, errors if errors
		
		return mapping
	end

		
	def createInstance(instance)
		begin
			response = RestClient.post settings.ns_instance_repository + '/ns-instances', instance.to_json, :content_type => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "NS-Instance Repository unavailable"
			end
			halt e.response.code, e.response.body
		end
		instance_id = JSON.parse(response)['instance_id']
		return instance_id
	end
	
	def instantiateVNF(instantiation_info)
		begin
			response = RestClient.post settings.vnf_manager + '/vnf-provisioning/vnf-instances', instantiation_info.to_json, :content_type => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "VNF-Manager unavailable"
			end
			halt e.response.code, e.response.body
		end
		
	end
	
	def sendMonitoringMetrics(parameters)
		begin
			response = RestClient.post settings.ns_monitoring + '/ns-monitoring/monitoring-parameters', parameters.to_json, :content_type => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "NS-Monitoring unavailable"
			end
			halt e.response.code, e.response.body
		end
	end
		
	def createMonitoringData(nsd)
		
		vnfs =  nsd['vnfs']
		monitor =  nsd['monitoring_parameters']
		
		monitoring = {:nsi_id => nsd['ns_id']}
		
		paramsVnf = []
		paramsNs = []
		assurance_parameters = nsd['assurance_parameters']
		i = 0
		monitor.each {|x|
			paramsVnf << {:id => i, :name => x['name'], :unit => x['unit']}
			paramsNs << {:id => i, :name => x['name'], :formula => assurance_parameters[i]['value']}
			i = i + 1
		}
		monitoring[:parameters] = paramsNs
		vnf_instances = []
		vnfs.each {|x|
			logger.error x
			vnf_instances << {:id => x, :parameters => paramsVnf}
		}
		monitoring[:vnf_instances] = vnf_instances
	
		logger.error monitoring.to_json
		logger.error JSON.pretty_generate(monitoring)
		
		return monitoring
	end
	
	def openstackAuthentication(user, password)
		auth = { "auth" => { "tenantName" => "admin", "passwordCredentials" => { "username" => user, "password" => password } } }
		begin
			response = RestClient.post settings.vim_identity_manager + ':5000/v2.0/tokens', auth.to_json, :content_type => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "Keystone not available"
			end
			halt e.response.code, e.response.body
		end
		
		authentication, errors = parse_json(response)
		return 400, errors if errors
		
		logger.error authentication.to_json
		logger.error authentication['access']['token']['id']
		
		return authentication['access']['token']['id']
	end
	
	def createProject(projectName, token)
		project = { "tenant" => { "description" => "", "enabled" => true, "name" => projectName }}
		begin
			response = RestClient.post settings.vim_identity_manager + ':35357/v2.0/tenants', project.to_json, :content_type => :json, :'X-Auth-Token' => token
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "Keystone not available"
			end
			halt e.response.code, e.response.body
		end
		
		project, errors = parse_json(response)
		return 400, errors if errors
		
		logger.error project.to_json
		logger.error project['tenant']['id']
		
		return project['tenant']['id']
	end
	
	def createUser(projectId, userName, password, token)
		user = { "user" => { "email" => userName+"@tnova.eu", "enabled" => true, "name" => userName, "password" => "secretsecret", "tenantId" => projectId}}
		begin
			response = RestClient.post settings.vim_identity_manager + ':35357/v2.0/users', user.to_json, :content_type => :json, :'X-Auth-Token' => token
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "Keystone not available"
			end
			halt e.response.code, e.response.body
		end
		user, errors = parse_json(response)
		return 400, errors if errors
		
		logger.error user.to_json
		logger.error user['tenant']['id']
		
		return user['user']['id']
		
	end
end

