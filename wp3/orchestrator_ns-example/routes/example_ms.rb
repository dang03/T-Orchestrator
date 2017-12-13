# @see ExampleMs
class ExampleMs < Sinatra::Application

  # WIP: Provisional implementation of background process
  def initialize()
    Thread.new do
      threaded
      inspector #main_loop process for service monitoring
    end
    super()
  end

	get '/examplems' do
    #calling helper function here
		status 200
		return exampleFunction()
	end

  get '/examplestream' do
    stream do |out|
      out << "Sending request...\n"
      sleep 2
      out << "Receiving response...\n"
    end
  end

  ##
  # SERVICE-PORT MONITORING

	get '/list_services' do
    #calling helper function here
    #logger.info("Get list of services")
		status 200
    #elements = list_of_services
    #return elements.to_json
    return hash_to_json()
	end

	get '/list_active_services' do
		status 200
		active_services = service_checker(on=true, off=false)
    return active_services.to_json
  end

  get '/list_inactive_services' do
    status 200
    inactive_services = service_checker(on=false, off=true)
    return inactive_services.to_json
  end

  ##
  # TESTINGS MONITORING

  # NS Catalogue
	#
	#post '/testings/catalogue' do |n|
    #nsd = load_nsd_example
    # n << params[nsd]
    # n.close
  #end

  get '/testings/catalogue' do
    #.. description..
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
    #.. do something..
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

  get '/' do
    #.. do something..
  end

  ##
  # STATISTICS MONITORING

  # Event Collector
	#
  post '/monitor' do
      # Return if content-type is invalid
      return 415 unless request.content_type == 'application/json'

      logger.info('Inserting statistical data')

      puts request.body.to_s

      #call event_collector() helper

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

    interval = cnf['interval']
    puts "Check interval: #{interval}"
    #main loop
    if interval != 0
      loop do
        puts Time.now
        service_checker(on=false, off=true)
        # Should load interval time from config:
        sleep(interval)
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


  #thread...
  #	EM.defer do
        #sleep 5
        #require "../helpers/monitoring"
        #elements = list_of_services
        #send alerts about the down microservices
    #end

  #  EM.run do
  #    EM.defer do
  #      EM.add_periodic_timer(5) do
  #        puts "time elapsed"
          #sleep 5
        #logs = IO.readlines('/var/log/kernel.log')
  #      end
  #    end
  #  end


end