# @see OrchestratorMonitoring
class OrchestratorMonitoring < Sinatra::Application

	def initialize()
		Thread.new do
			threaded
			inspector #main_loop process for service monitoring (status)
		end
		Thread.new do
			threaded
			health_inspector #main_loop process for service working tests (health)
		end
		super()
	end


	#example stream for testing purposes, should be deleted for production environment
	get '/examplestream' do
		stream do |out|
			out << "Sending request...\n"
			sleep 2
			out << "Receiving response...\n"
		end
	end


	##
	# SERVICE-PORT MONITORING

	# @method status
	# @overload get '/vnfs'
	# 	Post a VNF in JSON format
	# 	@param [JSON]
	# Post a VNF
	get "/status/:ip/:port" do
		res = is_port_open?(params["ip"], params["port"])
		return res.to_s
	end

	# return list of services
	# create alarms?
	get "/services" do
		#calling helper function here
		logger.info("Get list of services")
		status 201
		elements = list_of_services
		return elements.to_json
	end

	# return list of just active (current) services
	get "/active_services" do
		status 200
		active_services = service_checker(on=true, off=false)
		return active_services.to_json
	end

	# return list of stopped/unavailable services
	# create alarms?
	get "/inactive_services" do
		status 200
		inactive_services = service_checker(on=false, off=true)
		return inactive_services.to_json
	end

	# This method can get single service status or all services status taking as input the codename of the service or 'all' argument (ip address and port are not needed)
	# return status of a service (given its name) or returns all logged services status if a service name is not provided allowing to get a list of all services
	get "/services/:service" do
		status 200

		if params[:service] == 'all'
			# access saved status of services; return info/status of all known services (includes active and inactive)
			services_saved_status = get_services_state()
			return services_saved_status.to_s
		end

		s_params = single_service_check(params[:service])
		puts s_params
		if s_params == nil
			puts "Service not found!"
		end
		response = is_port_open?(s_params["service_host"], s_params["service_port"])
		puts response.to_s
		return s_params.to_s, response.to_s
	end


	##
	# TESTINGS MONITORING

	# NS Catalogue
	#
	get '/testings/catalogue' do
		# semantic tests for NS Catalogue -> Post a NSD and get same NSD to check correctness working of the service
		res = ns_catalogue_poster
		if res != (200 or 201)
			res.to_s
		else
			res_back = ns_catalogue_getter
			res_back.to_s
		end
	end


	# NS Monitoring
	#
	get 'testings/monitoring' do
		# semantic test for NS Monitor -> Not implemented yet
		halt 501, "Not implemented yet!"

		# Polling time loaded from config file
		#get_polling_time_from_file

		# Call helper method to craft special json object and send post to Data repository

	end


	# NSD Validator
	#
	get '/testings/validator' do
		res = nsd_validator_checker
		res.to_s
	end


	# GENERIC Service Health Check
	# TODO: Not implemented yet...
	get "/services/:service/health" do
		#status 200

		# Call to "Service Health API" to get response
		res = "health_checker"
		res.to_s
		# Check response -> Set health status
		#if params[:service] == 'all'
			# access saved status of services; return info/status of all known services (includes active and inactive)
			#services_saved_status = get_services_state()
			#return services_saved_status.to_s
		#end

		#puts name
		#path = service["path"]
		#puts path
		#ip = service["host"]
		#puts ip
		#port = service["port"]
		#puts port

	end

	##
	# STATISTICS MONITORING

	# Event Collector
	#
	#insert monitoring data received from NSProv., NSCatalog... (TODO:TBD, not finished)
	post "/monitor" do
		# Return if content-type is invalid
		return 415 unless
				request.content_type == 'application/json' or request.content_type == 'text/plainrn'

		status 201
		logger.info("Inserting statistical group data")
		#call event_collector() helper
		@content = request.body.read
		#put to file or DB
	end


	##
	# BACKGROUND CALLS

	def inspector
		require 'yaml'

		#load config values
		begin
			cnf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../config/config.yml'))

		rescue
			puts "ERROR: config file not found."
		end

		interval = cnf['stat_interval']
		puts "Check stat_interval value: #{interval}"+' seconds'

		#main loop
		if interval != 0
			loop do
				puts Time.now
				service_checker(on=false, off=true)
				sleep(interval)
			end

		end
	end

	def health_inspector
		require 'yaml'

		#load config values
		begin
			cnf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../config/config.yml'))
		rescue
			puts "ERROR: config file not found."
		end

		interval2 = cnf['test_interval']
		puts "Check test_interval value: #{interval2} seconds"

		#main loop
		if interval2 != 0
			loop do
				puts Time.now

				# Load file with saved services status / refresh saved services status
				begin
					services_data = get_services_state()
					puts "Services data loaded: #{services_data}"
				rescue
					puts "ERROR: status file not found."
				end

				service_tester(services_data)
				sleep(interval2)
			end
		end
	end


	def threaded
		Thread.new do
			loop do
				Kernel.exit if gets =~ /exit/
			end
		end
	end

end