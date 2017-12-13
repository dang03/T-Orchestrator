## Alessando Petrini - 2015 - Universita' degli studi di Milano
# @see sm-unimi
class MapperUnimi < Sinatra::Application


# --- CORS management
	before do
		content_type :json
		headers 'Access-Control-Allow-Origin' => '*',
				'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
	end
	#set :protection, false
# --- route OPTIONS for browser callings (again, CORS related...)
	options "*" do
		response.headers["Allow"] = "HEAD,GET,POST,DELETE,OPTIONS"
		response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
		response.headers["Access-Control-Allow-Origin"] = "*"
		200
	end	


	post '/vnsd' do
		return mapper_manager()
	end

# --- routing auxiliary function (GET to API NS Catalog simulation)
# used only if NSd api fails
# returns just the dummy service NS-1 as found on t-nova wiki
	get '/catalogue/:nsid' do
		return dummy_NScatalogue(params[:nsid])
	end

# --- routing auxiliary function (GET to API VNF Catalog simulation)
# returns just the vnfd id
	get '/vnfd_catalogue/:vnfd' do
		return dummy_VNFcatalogue(params[:vnfd])
	end



	get '/callSS' do
		#calling helper function here
		status 200
		invokeMapper( 'null', 'null', 'null' )
		return exampleFunction()
	end


end

