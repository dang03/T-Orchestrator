# helper classes to perform a better CLI output

require 'net/http'
require 'uri'

class Colors
  COLOR1 = "\e[1;36;40m"
  COLOR2 = "\e[1;35;40m"
  NOCOLOR = "\e[0m"
  RED = "\e[1;31;40m"
  GREEN = "\e[1;32;40m"
  DARKGREEN = "\e[0;32;40m"
  YELLOW = "\e[1;33;40m"
  DARKCYAN = "\e[0;36;40m"
end

class String
  def color(color)
    return color + self + Colors::NOCOLOR
  end
end


# @see OrchestratorMonitoring
class OrchestratorMonitoring < Sinatra::Application

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

  # Converts JSON data to hash format (hash_to_json reverse)
  #
  # @return is a list that contains hash objects of microservices names, ips and ports.
  def list_of_services(name=nil)
    file = File.read('config/ms_ports.json')
    data_hash = JSON.parse(file)
    if name
      return data_hash[name]
    else
      return data_hash
    end

  end

  # Converts a hash to JSON format (This is an OLD METHOD used for testings purposes, can be removed from code)
  #
  # @return is a list that contains microservices names, ips and ports.
  # It will be configurable from a config file
  def hash_to_json
    old_list_ms = [{:name => "NS_Catalogue", :ip => nil, :port => 4011},
                   {:name => "NS_Provisioner",  :ip => nil, :port => 4012},
                   {:name => "NS_Inst_Repo", :ip => nil, :port => 4013},
                   {:name => "NS_Monitoring", :ip => nil, :port => 4014},
                   {:name => "NSD_Validator", :ip => nil, :port => 4015},
                   {:name => "NS_SLA_Enforcement", :ip => nil, :port => 4016},
                   {:name => "NS_Mapping", :ip => nil, :port => 4042}]

    list_ms = [{:service_name => "monitoring", :service_path => nil, :service_host => "127.0.0.1", :service_port => 4003},
               {:service_name => "authentication", :service_path => nil, :service_host => "127.0.0.1", :service_port => 4001},
               {:service_name => "authorization", :service_path => nil, :service_host => "127.0.0.1", :service_port => 4002},
               {:service_name => "nscatalogue", :service_path => "/network-services", :service_host => "127.0.0.1", :service_port => 4011},
               {:service_name => "nsprovisioning", :service_path => "ns-instances", :service_host => "127.0.0.1", :service_port => 4012},
               {:service_name => "nsmonitoring", :service_path => "/ns-monitoring", :service_host =>"127.0.0.1", :service_port => 4014},
               {:service_name => "vnfmanager", :service_path => "/vnfs", :service_host => "193.136.92.205", :service_port => 4567}]

    jsonified_list_ms = list_ms.to_json
    return jsonified_list_ms
  end

  ##
  # SERVICE-PORT MONITORING

	# Checks if a Port is open
	#
	# @param [ip] ip of service
	# @param [port] port of service
	# @return [Boolean] is open or not
	def is_port_open?(ip, port)
	  begin
		Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
		  s.close
          return true
		rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
		  return false
        end
	  end
	  rescue Timeout::Error
	  end
	  return false
  end

  # Gets path data from each known service and checks if they are alive.
  # Then returns those services that are not connected.
  #
  # @param [ip] ip of service
  # @param [port] port of service
  # @return [Boolean] is open or not
	def list_of_inactive_services
	  services = JSON.parse(RestClient.get(settings.manager + '/configs/services').body)
	  elements = []
	  services.each do |service|
		stat = is_port_open?(service['host'], service['port'])
		if stat == false
		  elements.push(service)
		end
	  end
	  return elements
	end


  def update_list_of_services()
    #TODO: URI could be configurable, being read from config file to allow changes on sources
    #result = Net::HTTP.get(URI.parse('http://apis.t-nova.eu/orchestrator/configs/services'))
    result = Net::HTTP.get(URI.parse(settings.api_source))
    File.write('config/ms_ports.json', result)
  end

  # Checks if every connected microservice is alive
	#
	def service_checker(on=false, off=false)
    begin
		  ms_ports = list_of_services()
    rescue
      update_list_of_services()
      ms_ports = list_of_services()
    end

    elements_on = []
    elements_off = []

    ms_ports.each do |service|
      name = service["name"]
      path = service["path"]
      ip = service["host"]
      port = service["port"]

      status = is_port_open?(ip, port)
      if status # true == is connected aka service is "up"
        puts "Service: #{name}, Path:#{path}, IP: #{ip}, Port: #{port} is " + "connected".color(Colors::GREEN)
        elements_on.push(service)

        service_stats(name, "up", nil)
        service_status_pusher(name, "up")

      else
        # status is false
        puts "Service: #{name}, Path:#{path}, IP: #{ip}, Port: #{port} is " + "disconnected".color(Colors::RED)
		    elements_off.push(service)

        service_stats(name, "down", nil)
        service_status_pusher(name, "down")

      end
    end

    if on
      return elements_on
    elsif off
      return elements_off
    end

  end

  def single_service_check(name=nil)
    #This method can return information of single service providing its name, such its path, host, port and status
    # if no name is provided, it returns all the services information saved in the ms_port.json file

    require 'json'

    file = File.read('config/ms_ports.json')
    data_hash = JSON.parse(file)

    if name
      data_hash.each do |service|
        if service["name"] == name.to_s
          return service
        end
      end
      return nil
    else
      return data_hash
    end
  end

  # Retrieve service data logged in status.json file
  #
  # @return is a list that contains hash objects of microservices names, and its status.
  def get_services_state()
    file = File.read('config/status.json')
    data_hash = JSON.parse(file)
    return data_hash
  end


  ##
  # TESTINGS MONITORING

  # These methods are service dependant -> They will be modified to work on service side
  #
  def ns_catalogue_poster()
    url = 'http://apis.t-nova.eu:4011/network-services'
    puts url
    uri = URI.parse(url)
    puts uri

    params = File.read('config/catalogue_nsd.json')
    puts params

    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)

    #request.set_form_data('code' => token, 'client_id' => @client_id, 'client_secret' => client_secret, 'redirect_uri' => googleauth_url, 'grant_type' => 'authorization_code')
    request.content_type = 'application/json'
    request.body = params
    response = http.request(request)
    response.code

    if response.code == 201
      puts "#{response.code}".color(Colors::GREEN)
    else
      puts "#{response.code}".color(Colors::RED)
    end

    return response.code
  end

  def ns_catalogue_getter()
    result = Net::HTTP.get(URI.parse('http://apis.t-nova.eu:4011/network-services/12'))
    puts result
    return result
  end

  # Description
  #
  def ns_monitoring_checker()
    #.. do something..
    #TODO: Not implemented
  end

  # Description
  #
  def nsd_validator_checker()
    #.. do something..
    url = 'http://apis.t-nova.eu:4015/nsds'
    uri = URI.parse(url)

    #if version == 'OK'
    #  params = File.read('../config/template_nsd.json')
    #  Net::HTTP.post_form(uri, params)
    #else
    #  params = File.read('../config/bad_nsd.json') #if version == 'BAD'
    #  Net::HTTP.post_form(uri, params)
    #end

    params = File.read('config/template_nsd.json')
    #puts params

    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)

    #puts uri.request_uri

    #request.set_form_data('code' => token, 'client_id' => @client_id, 'client_secret' => client_secret, 'redirect_uri' => googleauth_url, 'grant_type' => 'authorization_code')
    request.content_type = 'application/json'
    request.body = params
    #puts "BODY", request.body
    response = http.request(request)
    response.code

    #puts response.code
    return response.code
  end


  def service_tester(active_services) # <---------------- THIS METHOD WILL BE OVERRIDDEN!!!

    active_services.each do |service|
      # Apply semantic tests for each core microService:
      name = service["name"]
      if name == "monitoring"
        #do something...
        puts "MONITORING test:" + "Unavailable".color(Colors::YELLOW)

      elsif name == "authentication"
        #do something...
        puts "AUTHENTICATION test:" + "Unavailable".color(Colors::YELLOW)

      elsif name == "authorization"
        #do something..
        puts "AUTHORIZATION test:" + "Unavailable".color(Colors::YELLOW)

      elsif name == "nscatalogue"
        #TODO:
        # Call to URL get '/testings/catalogue'
        code = ''
        puts "NSCATALOGUE test:" + "#{code}".color(Colors::YELLOW)

      elsif name == "nsprovisioning"
        #do something..
        puts "NSPROVISIONING test:" + "Unavailable".color(Colors::YELLOW)

      elsif name == "nsmonitoring"
        #do something..
        puts "NSMONITORING test:" + "Unavailable".color(Colors::YELLOW)

      elsif name == "vnfmanager"
        #do something..
        puts "VNFMANAGER test:" + "Unavailable".color(Colors::YELLOW)

      elsif name == "nsdvalidator"
      #TODO:
      # Call to URL get '/testings/validator' do
      code = ''
      puts "NSDVALIDATOR test:" + "#{code}".color(Colors::YELLOW)

      end

      #puts name
      #path = service["service_path"]
      #puts path
      #ip = service["service_host"]
      #puts ip
      #port = service["service_port"]
      #puts port

    end

  end

  ##
  # STATISTICS MONITORING

  # Description
	#
  def event_collector()
    #.. do something..
    #TODO: what we receive? Data statistics must be defined in order to implement an event_collector
  end

  ##
  # MISCELLANEOUS METHODS

  def service_stats(servicename, servicestatus, servicehealth)
    #Description: each microservice will have 2 states
    # -Status: UP/DOWN ; Port connection
    # -Health: OK/BAD ; Semantic tests
    #read/create json file to save microservices status

    require 'json'
    require 'pp'

    #Should we create a DB or use JSON notation to store stats related to some services
    begin
      file = File.read('config/status.json')
    rescue
      # Call method to build a blank "status.json" file"
      file = new_status_file()
    end

    file_hash = JSON.parse(file)
    done = false

    for service in file_hash do
      if service['name'] == servicename
        service['status'] = servicestatus
        done = true
        puts "SERVICE: #{service} updated"
      end
    end

    if !done
      puts "SERVICE: #{servicename} NOT FOUND"
      file_line = {'name' => servicename, 'status' => servicestatus, 'health' => nil}
      file_hash << file_line
      puts "New SERVICE: #{servicename} added"
    end

    file_jsonified = file_hash.to_json
    File.write('config/status.json', file_jsonified)

    return file_hash
  end


  def service_status_pusher(service_name, service_status)
    #TODO: Update status information to NS Manager DB
    #put '/configs/services/:name/status' do
    #  @service = ServiceModel.find_by(name: params["name"])
    #  @service.update_attribute(:status, request.body.read)
    #  return "Correct update."
    #end

    #CALL METHOD WITH:
    #http://localhost:4000/configs/services/:name/status
    #Where :name its service_name and body contains status (health? not used yet)

    require 'net/http'
    require 'uri'

    url = settings.manager + "/configs/services/#{service_name}/status"
    #puts url
    uri = URI.parse(url)
    #puts uri

    params = service_status

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.content_type = 'text/plainrn' #<--- Text / Non-type
    request.body = params

    begin
      response = http.request(request)
      response.code

      if response.code == 201
        puts "#{response.code}".color(Colors::GREEN)
      else
        puts "#{response.code}".color(Colors::RED)
      end

      return response.code

    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
      puts "#{e.message}".color(Colors::RED)
    end

  end


  # This is a "utils" method to create new blank loggin file for saving services status locally
  def new_status_file()

    File.new('config/status.json', 'w+')

    file_source = File.read('config/ms_ports.json')
    data_hash = JSON.parse(file_source)
    services = []

    data_hash.each do |service|
      name = service["name"]
      file_line = {'name' => name, 'status' => nil, 'health' => nil}
      services.push(file_line)
    end

    file_result = services.to_json
    File.write('config/status.json', file_result)
    return file_result
  end

end

