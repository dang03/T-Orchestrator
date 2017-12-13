# @see NSMonitoring
class NSMonitoring < Sinatra::Application

	#definition metric should be monitoring, recevied from NSProvisioning
	#	{
	#  "nsi_id": "1",
	#  "vnf_instances": [
	#    { "id": "1", "parameters": [
	#      { "id": "1", "name": "availability", "unit": "percentage"},
	#      { "id": "2", "name": "num_sessions", "unit": "integer"} ]
	#    },
	#    { "id": "2", "parameters": [
	#      { "id": "1", "name": "availability", "unit": "percentage"},
	#      { "id": "2", "name": "num_sessions", "unit": "integer"} ]
	#    }
	#  ],
	#  "parameters": [
	#    { "id": "1", "name": "availability", "formula": "min(vnf_instance[1].availability, vnf_instance[2].availability)"},
	#    { "id": "2", "name": "num_sessions", "formula": "vnf_instances[1].num_sessions+vnf_instances[2].num_sessions"}
	#  ]
	#}
	post '/ns-monitoring/monitoring-parameters' do
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		json, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		@monitoring_metrics = create_monitoring_metric_object(json)
		@monitoring_metrics.save!

		#publish method - TODO
		parameters = []
		@monitoring_metrics.vnf_instances.each do |e|
			parameters.push(e)
		end
		logger.error parameters.to_json
				#send to VNF-Monitoring the metrics to monitor
		#RestClient.post settings.vnf_manager + '/vnf-manager/vnf-instances/:id/monitoring-parameters', json.to_json, :content_type => :json, :accept => :json
		#	{
		#"parameters": [
		#{ "id": "1", "name": "availability", "unit": "percentage"},
		#{ "id": "2", "name": "num_sessions", "unit": "integer"}
		#]
		#}
		#[{"parameters":[{"id":41,"name":"availability","unit":"%"},{"id":42,"name":"ram-consumption","unit":"MB"}]}]

	end
	get '/ns-monitoring/monitoring-parameters' do
		return	MonitoringMetric.all
	end
		#This interface is with the VNF Monitoring micro-service, upon successfully receiving a monitoring parameter reading for a given VNF instance.
	#	{
	#  "parameter_id": "1",
	#  "value": "99.99",
	#  "timestamp": "2015-06-18T09:42:10Z"
	#}
	post '/ns-monitoring/vnf-instance-readings/:vnf_instance_id' do
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		json, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors
				@vnf_monitoring_data = VNFMonitoringData.new json
		puts @vnf_monitoring_data.inspect
		#compose
		#given the vnf_instance_id, search in which ns_id belongs to
		#given the parameter_id of this request, serach the paramter info of that vnf_id
		#the data should be in the following format: {metric: 'cpu', value: '10'}
				#generate metric-value
		json = generateMetric('cpu', 'value')
		#store agreggated metrics to the Cassandra DB
		RestClient.post settings.ns_monitor_db + '/ns-monitoring/:vnf_instance_id', json.to_json, :content_type => :json, :accept => :json
	end
		#This interface is with the SLA Enforcement micro-service, upon successfully registering .
	post '/ns-monitoring' do
		#todo, what we receive?

	end
	get '/test' do
		json, errors = parse_json(RestClient.get 'http://localhost:4011/network-services/12', :accept => :json)
		return 400, errors.to_json if errors

		vnfs =  json['vnfs']
		monitor =  json['monitoring_parameters']
		obj = MonitoringMetric.new(nsi_id: json['ns_id'])
		print obj.to_json
		params = []
		assurance_parameters = json['assurance_parameters']
		i = 0
		monitor.each {|x|
			params << Parameter.new(name: x['name'], unit: x['unit'], formula: assurance_parameters[i]['value'])
			i = i + 1
		}
		vnf_instances = []
		vnfs.each {|x|
			vnf_instances << VnfInstance.new(parameters: params)
		}
		obj.vnf_instances.push(vnf_instances)
		obj.parameters.push(params)
		obj.save
		return obj.to_json		
	end
end

