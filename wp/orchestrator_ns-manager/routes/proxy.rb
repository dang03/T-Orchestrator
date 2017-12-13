# @see TnovaManager
class TnovaManager < Sinatra::Application
	get '/:path*' do
		if params["path"].match('vnf')
			params["path"] = 'vnf-manager'
		end
				
		logger.info("GET - Received request to forward to " + params["path"] + " microservice ")
		@service = ServiceModel.where(path: "/" + params["path"]).last(1)[0]
		if @service
			logger.error "mS Exists ----------------"
			new_url = "http://" + @service.host + ":" + @service.port.to_s + request.fullpath
		else
			logger.error "mS no Exists ----------------"
			halt 500, {'Content-Type' => "text/plain"}, "Microservice unrechable."
		end

		logger.error new_url
		#halt e.response.code, e.response.body
		#halt 500, {'Content-Type' => "text/plain"}, "Microservice unrechable."

		require 'open-uri'
		uri = URI.parse(new_url)
		getresult = uri.read
		halt 200, {'Content-Type' => getresult.content_type}, getresult

		#redirect new_url
	end

	post "/:path*" do
		if params["path"].match('vnf')
			params["path"] = 'vnf-manager'
		end
		logger.info("POST - Received request to forward to " + params["path"] + " microservice ")
		@service = ServiceModel.where(path: "/" + params["path"]).last(1)[0]
		new_url = "http://" + @service.host + ":" + @service.port.to_s + request.fullpath
#		RestClient.post(new_url, params, :accept => :json, :authorization => @@auth) {|response, request, result| halt response.code, response.headers, response.body}
		begin
			RestClient.post(new_url, request.body.read, :content_type => :json) {|response, request, result| halt response.code, response.headers, response.body}
		rescue => e
			logger.error e
			halt e.response.code, e.response.body
		end
		#RestClient.post(new_url, params, :content_type => :json) {|response, request, result| halt response.code, response.headers, response.body}
		#redirect new_url, 307
	end

	delete "/:path*" do
		if params["path"].match('vnf')
			params["path"] = 'vnf-manager'
		end
		logger.info("POST - Received request to forward to " + params["path"] + " microservice ")
		@service = ServiceModel.where(path: "/" + params["path"]).last(1)[0]
		new_url = "http://" + @service.host + ":" + @service.port.to_s + request.fullpath
#		RestClient.post(new_url, params, :accept => :json, :authorization => @@auth) {|response, request, result| halt response.code, response.headers, response.body}
		begin
			RestClient.delete(new_url, request.body.read, :content_type => :json) {|response, request, result| halt response.code, response.headers, response.body}
		rescue => e
			logger.error e
			halt e.response.code, e.response.body
		end
		#RestClient.post(new_url, params, :content_type => :json) {|response, request, result| halt response.code, response.headers, response.body}
		#redirect new_url, 307
	end

end

