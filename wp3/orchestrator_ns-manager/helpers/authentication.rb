# @see TnovaManager
class TnovaManager < Sinatra::Application

	def registerServiceinGK(serviceName)
		service = {"shortname" => serviceName, "description" => ""}
		begin
			logger.error settings.gatekeeper + '/admin/service/'
			logger.error service.to_json
			key = RestClient.post settings.gatekeeper + '/admin/service/', service.to_json, :content_type => :json, :accept => :json
		rescue => e
			if e.response == nil
				halt 500, {'Content-Type' => 'text/plain'}, "Register service error."
			end
			halt 400, {'Content-Type' => 'text/plain'}, e.response
		end
		userName = serviceName
		registerUserinGK(userName, "ALL")
		return key
	end
	
	def registerUserinGK(userName, accessList)
		user = {
			"username" => userName,
			"password"=>"somepass",
			"isadmin" => "n",
			"accesslist" => accessList
		}
		begin
			user = RestClient.post settings.gatekeeper + '/admin/user/', user.to_json, :content_type => :json, :accept => :json
		rescue => e
			if e.response == nil
				halt 500, {'Content-Type' => 'text/plain'}, "Register user error."
			end
			halt 400, {'Content-Type' => 'text/plain'}, e.response
		end
		return user
	end
	
	#send service key to a mS
	def sendServiceAuth(microservice, key, user, pass)
		credentials = {key: key, user: user, pass: pass}
		begin
			RestClient.post microservice + '/gk_credentials', credentials.to_json, :content_type => :json
		rescue => e
			logger.error e
			if e.response == nil
				halt 500, {'Content-Type' => 'text/plain'}, "MS unrechable."
			end
			halt 400, {'Content-Type' => 'text/plain'}, e.response
		end
	end

end
