require 'sinatra/base'
require 'json'

module Sinatra
  module Auth
    module Helpers
            
      def authorized?
        logger.error ENV["token"]
			if ENV["token"].to_s.empty?
				halt 401, {'Content-Type' => 'text/plain'}, 'Token invalid.'
			end
			
			begin
			RestClient.get ENV["gk"] + '/token/validate/'+ENV["token"].to_s, :content_type => :json, :"x-auth-uid" => 3
			rescue => e
				logger.error e
				if e.response == nil
					halt 500, {'Content-Type' => 'text/plain'}, "Token error."
				end
				halt 400, {'Content-Type' => 'text/plain'}, e.response
			end
      end
      
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
    end

    def self.registered(app)
      app.helpers Auth::Helpers

      app.set :username, 'frank'
      app.set :password, 'changeme'

      app.post '/gk_credentials' do
		logger.error "Recevied credentials in gem"
		
		#credentials = {key: key, user: user, pass: pass}
		# Return if content-type is invalid
		#return 415 unless request.content_type == 'application/json'
		# Validate JSON format
		credentials, errors = parse_json(request.body.read)
		return 400, errors.to_json if errors
		
		logger.error credentials
		logger.error credentials['key']
		logger.error credentials['user']
		logger.error credentials['pass']
		
		app.set :gk_key, credentials['key']
		ENV["key"] = credentials['key']
		logger.error(options.gk_key)
		
		begin
			token = RestClient.post ENV["gk"] + '/token/',{}, :content_type => :json, :"x-auth-password" => credentials['pass'], :"x-auth-uid" => 3
		rescue => e
			logger.error e
			if e.response == nil
				halt 500, {'Content-Type' => 'text/plain'}, "Register user error."
			end
			halt 400, {'Content-Type' => 'text/plain'}, e.response
		end
		
		
		logger.error token
		metadata = ::JSON.parse(token)
		logger.error metadata
				
		ENV["token"] = metadata["token"]["id"].to_s
		app.set :gk_token, metadata["token"]["id"].to_s
		logger.error(options.gk_token)
		
		#get token using user and pass
		#curl -X POST auth.piyush-harsh.info:8000/token/ --header "Content-Type:application/json" --header "X-Auth-Password:somepass" --header "X-Auth-Uid:1"
		#return RestClient.get settings.ns_instance_repository + '/token'
	end
      
    end
  end

  register Auth
end