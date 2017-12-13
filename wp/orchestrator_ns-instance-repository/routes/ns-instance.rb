# @see OrchestratorNsInstanceRepository
class OrchestratorNsInstanceRepository < Sinatra::Application

	get '/ns-instances' do
		@nsInstances = NsInstance.all
		return @nsInstances.to_json
	end
	get '/ns-instances/:id' do
		begin
			@nsInstance = NsInstance.find(params["id"].to_i)
		rescue ActiveRecord::RecordNotFound
			halt(404)
		end
		return @nsInstance.to_json
	end 

	post '/ns-instances' do
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		instance, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors
		
		instance = NsInstance.new(instance)
		instance.save!
		response = { :instance_id => instance.id }

		return 200, response.to_json
	end

	put '/ns-instances/:id' do
		# Return if content-type is invalid
		return 415 unless request.content_type == 'application/json'

		# Validate JSON format
		@nsInstance, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors

		begin
			@instance = NsInstance.find(params["id"].to_i)
		rescue ActiveRecord::RecordNotFound
			halt(404)
		end
		@instance.update_attributes(@nsInstance)
		status 200
	end
	delete '/ns-instances/:id' do
		begin
			@nsInstance = NsInstance.find(params["id"].to_i)
		rescue ActiveRecord::RecordNotFound
			halt(404)
		end
		@nsInstance.delete
	end

end
