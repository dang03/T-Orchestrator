# Alessandro Petrini, 2015 - Unimi
# test with curl:
# curl -X POST localhost:4042/vnsd -H 'Content-Type: application/json' -d '{"NS_id":"2"}'
# @see sm-unimi
class MapperUnimi < Sinatra::Application

	def mapper_manager()
		return_message = {}
		puts request.body.read
		request.body.rewind
		jdata = JSON.parse(request.body.read)
		#look for the NS_id
		if jdata.has_key?('NS_id') 
			ns_id = jdata['NS_id']
	  	else
			return_message = "\nERROR: invalid JSON request!\n\n"
			puts return_message
			status 400
			return '{"error": "Invalid JSON request"}'
		end

		# query NS catalogue
		begin
			nsd_from_catalogue = RestClient.get 'http://apis.t-nova.eu/orchestrator/network-services/' + ns_id
		rescue => e
			# Please Note: in this file we also simulate the API for answering to this query
			puts "API not working! Using emulated NS catalog request!"
			nsd_from_catalogue = RestClient.get 'http://localhost:4042/catalogue/' + ns_id
		end
		nsd_from_catalogue_hash = JSON.parse(nsd_from_catalogue)
		if nsd_from_catalogue_hash.has_key?('error')
			return_message = "\nERROR: no match in NS catalogue!\n\n"
			puts return_message
			status 404
			return '{"error": "No match in NS catalogue"}'
		end

		# query a Virtual Function catalogue
		# Please Note: in this file we also simulate the API for answering to this query
		# As now, it returns just the vfd id and no corresponding resource
		if nsd_from_catalogue_hash.has_key?('vnfs')
			list_of_vnfd_in_nsd_hash = nsd_from_catalogue_hash['vnfs']
		else
			status 404
			return '{"error": "No vnfs in NS"}'
		end
		vnfd_ret = Hash.new
		vnfd_id = 0
		list_of_vnfd_in_nsd_hash.each do | vnfd_desc |
			vnfd_id += 1
			# -- TODO: retrieve also the required resources of the vnfd and not just its id
			vnfd_from_catalogue = RestClient.get 'http://localhost:4042/vnfd_catalogue/' + vnfd_desc
			vnfd_id_str = vnfd_id.to_s
			vnfd_ret.store("vnf-"+vnfd_id_str, vnfd_from_catalogue)
		end
		vnfd_list_json = JSON.pretty_generate(vnfd_ret)

		# saving query to NS catalogue
		open('bin/NSd.json', 'w') do |f|
			f.puts nsd_from_catalogue
		end
		# saving query to VF catalogue
		open('bin/VNFd.json', 'w') do |f|
			f.puts vnfd_list_json
		end

		# query to Infrastructure Repository
		# -- TODO --
		# saving query to Infrastructure Repository
		# -- TODO --
		# system call to the solver: system("./glpk_solver NSd.json IRstatus.json")
		# -- TODO --
		# solver has retuned a json file containg the solution (or the error)
		# return solution to Orchestrator
		#return JSON.pretty_generate(mapper_hash)


		# for demo purpose, we build this return value into the ruby script
		# we modify the solution template json file SM_solution_template.json
		mapper_solution_json = File.read('json_templates/SM_solution_template.json')
		mapper_hash = JSON.parse(mapper_solution_json)
		mappings = Array.new
		puts vnfd_ret
		vnfd_ret.each do | id, vnfd_desc |
			per_vnf_map = Hash.new
			per_vnf_map.store("vnf", vnfd_desc)
			per_vnf_map.store("pop", "pop-1")
			mappings.push(per_vnf_map)
		end
		mapper_hash['NS_id'] = ns_id
		mapper_hash['mappings'] = mappings
		mapper_hash['connection-graph'] = ""
		time1 = Time.new
		mapper_hash['created_at'] = time1.inspect
		mapper_hash['updated_at'] = time1.inspect

		return JSON.pretty_generate(mapper_hash)
	end


	def dummy_NScatalogue(ns_id)
		#content_type :text
		#puts '\n'	
		#puts( JSON.pretty_generate(request.env) )
		puts "\n"
		puts "NS request: " + ns_id
		puts "\n"
		if ns_id == "2"
			file = File.read('json_templates/NSD_example_v1.json')
			hashed_json = JSON.parse(file)
			return JSON.pretty_generate(hashed_json)
		else
			return '{"error": "No match in NS catalogue"}'
		end
	end


	def dummy_VNFcatalogue(vnf_id)
		content_type :text
		puts "\n"
		puts "vnfd request:" + vnf_id
		puts "\n"
		#dummy output for vnf descriptors.
		return vnf_id
		# -- TODO --
		#return vnfd and associated resources
	end


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

	def exampleFunction()
		return "Example Function"
	end

	def invokeMapper(nsd, vnfd, networkd)
		puts "invocato il mapper!\n"
		status 200
		system("bin/super")
		return "ok"
	end


end

