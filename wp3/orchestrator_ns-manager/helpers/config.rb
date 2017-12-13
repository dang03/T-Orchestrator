# @see TnovaManager
class TnovaManager < Sinatra::Application

	def registerService(json)
		@json = JSON.parse(json)
		#if is duplicated, we should update, for the moment
		status = ServiceModel.exists?(:name => @json['name'])
		if !status
			begin
				@service = ServiceModel.new(@json).save!
				key = registerServiceinGK(@json['name'])
				logger.error "KEY:"
				logger.error key
				metadata = JSON.parse(key)
				access = @json['host'] +":"+ @json['port'].to_s
				sendServiceAuth(access, metadata["info"][0]["service-key"], @json['name'], "somepass")
				return "Service registered"
			rescue => e
				logger.error "RESCUE config"
				logger.error e
				halt 500, {'Content-Type' => 'text/plain'},"Error registering the service"
			end
		else
			@service = ServiceModel.find_by(:name => @json['name'])
			@service.update_attributes(@json)
			return "Service updated"
		end
		status 201
	end

	def unregisterService(name)
		settings.services[name] = nil
		ServiceModel.find_by(name: params["microservice"]).delete
	end

	def updateService(service)
		#@service = settings.services[params['name']]
		#@services[@service['name']] = @json
		@service = ServiceModel.find_by(name: params["name"])
		@service.update_attributes(@json)
	end

	# Unregister all the services
	def unRegisterAllService
		ServiceModel.delete_all
	end

	# Check if the token of service is correct
	def auth(key)
		#TODO
		#return response
		status 201
	end

end
