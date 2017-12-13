# @see OrchestratorNsProvisioner
class OrchestratorNsProvisioner < Sinatra::Application
	get '/ns-instances' do
		return RestClient.get settings.ns_instance_repository + '/ns-instances'
	end
	# @method post_ns
	# @overload post '/ns'
	# 	Post a NS in JSON format
	# 	@param [JSON]
	# Post a NS
	#Request body: {"ns_id": "987"}'
	post '/ns-instances' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'
		# Validate JSON format
		ns, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors


		nsd = getNSD(ns['ns_id'].to_s)
		logger.error nsd.to_json
				
		#mon_data = createMonitoringData(nsd)
		#sendMonitoringMetrics(mon_data)
		#return
				
		ms = {"NS_id" => "1"}
		#mapping = callMapping(ms)
		
		#Send instantiation to NS Instance repository
		instance = { :ns_id => ns['ns_id'], :status => "instantiated"}
		instance_id = createInstance(instance)

		# TODO: This could go into an helper method
		# Find SLA Enforcement IP address
		begin
			response = RestClient.get settings.services_list, :accept => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "Service list unavailable"
			end
			halt e.response.code, e.response.body
		end
		sla_enforcement_info = response.detect {|service| service['service_name'] == 'sla-enforcement'}
		# Call SLA Enforcement
		parameters = []
		nsd['assurance_parameters'].each do |assurance_parameter|
			#TODO: minimum and maximum parameters
			parameters.push({:param_name => assurance_parameter['param_name'], :minimum => nil, :maximum => nil})
		end

		sla = {:nsi_id => instance_id, :parameters => parameters}
		begin
			response = RestClient.post "#{sla_enforcement_info['service_host']}:#{sla_enforcement_info['service_port']}/sla-enforcement/slas", sla.to_json, :content_type => :json
		rescue => e
			logger.error e
			if (defined?(e.response)).nil?
				halt 503, "SLA-Enforcement unavailable"
			end
			halt e.response.code, e.response.body
		end
				
#		token = openstackAuthentication(settings.vim_user, settings.vim_pass)
#		project_id = createProject(instance_id, token)
		
		userName = "user_"+instance_id
		password = "secretsecret"
#		createUser(project_id, userName, password, token)
		
		#Send instantiation to the VNF Manager for each vnf id
		#send credentials to the VNF-Manager
		logger.error nsd['vnfs'].to_json
		vnfs = nsd['vnfs']
#		for vnf in vnfs
#			instantiation_info = {:vnf => vnf, :auth => {:tenant => project_id, :name => userName, :password => password}}
#			instantiateVNF(instantiation_info)
#		end
		
		#send monitoring parameters to the NSMonitoring
		#print ns.to_json
		#mon_data = createMonitoringData(nsd)
		#sendMonitoringMetrics(mon_data)
		
		
		return 200, instance_id.to_s
	end
	
	#Deployment using POST inserting the status in the body req.
	#'{"status": "deployed"}'
	post '/ns-instances/:ns_id' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'
		# Validate JSON format
		ns, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors
		#check if the request NS_id exists
		stat = RestClient.get settings.ns_catalogue + '/network-services/' + ns['ns-id']
		print stat
		status 200
	end
end
