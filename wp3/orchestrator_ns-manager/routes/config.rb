# @see TnovaManager
class TnovaManager < Sinatra::Application

	post '/configs/registerService' do
		return registerService(request.body.read)
	end

	post '/configs/unRegisterService/:microservice' do
		logger.info("Unregister service " + params["microservice"])
		unregisterService(params["microservice"])
		logger.info("Service " + @json['name'] + " unregistred correctly")
	end

	delete '/configs/services' do
		ServiceModel.find_by(name: params["name"]).delete
	end

	get '/configs/services' do
	    if params['name']
			return ServiceModel.find_by(name: params["name"]).to_json
			#return settings.services[params['name']].to_json
	    else
			return ServiceModel.all.to_json
			#return settings.services.to_json
	    end
	end

 #'/configs/services?name=servicename
	put '/configs/services' do
		updateService(request.body.read)
		return "Correct update."
	end
	
	put '/configs/services/:name/status' do
		@service = ServiceModel.find_by(name: params["name"])
		@service.update_attribute(:status, request.body.read)
		return "Correct update."
	end
	

	#request to the postresql db and request the last port used.
	#to remove... use the registerService
	#get '/configs/registerRequest/:microservice/?:port?' do
	#	ip = request.ip
	#	if params["port"] == nil
	#		if ServiceModel.last(1).size == 0
	#			port = 4001
	#		else
	#			port = ServiceModel.last(1)[0].port + 1
	#		end
	#	else
	#		port = params["port"]
	#	end
	#	uri = URI('http://127.0.0.1:4000/registerService')
	#	http = Net::HTTP.new(uri.host, uri.port)
	#	http.read_timeout = 5
	#
	#	req = Net::HTTP::Post.new(uri)
	#	req.body = {
	#		"service_name" => params["microservice"],
	#		"service_host" => ip,
	#		"service_port" => port.to_s
	#	}.to_json
	#	#http.request(req)
	#	http = Net::HTTP.new(uri.host, uri.port)
	#	http.read_timeout = 5
	#	http.set_debug_output $stderr
	#	#http.start
	#	request = Net::HTTP::Post.new uri
	#	content = {
	#		"service_name" => params["microservice"],
	#		"service_host" => ip,
	#		"service_port" => port.to_s
	#	}.to_json
	#	request.body = content
	#	#response = http.request request # Net::HTTPResponse object
	#	registerService(content)
	#	#RestClient.post uri.to_s, content.to_json, :content_type => :json, :timeout => 5
	#	return port.to_s
	#end
end

