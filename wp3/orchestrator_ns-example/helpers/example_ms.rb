# @see ExampleMs

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

class ExampleMs < Sinatra::Application

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


  # Example base function
  #
  def example_function()
    return "Example Function"
	end

  # Converts a hash to JSON format
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

  def update_list_of_services()
    result = Net::HTTP.get(URI.parse('http://apis.t-nova.eu/orchestrator/configs/services'))
    File.write('config/ms_ports.json', result)
  end

  # Converts JSON data to hash format (hash_to_json reverse)
  #
  # @return is a list that contains hash objects of microservices names, ips and ports.
	def list_of_services
		file = File.read('config/ms_ports.json')
		data_hash = JSON.parse(file)
	  return data_hash
  end

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

  # Checks if every connected microservice is alive
	#
	def service_checker(on=false, off=false)
		ms_ports = list_of_services
    elements_on = []
    elements_off = []

    ms_ports.each do |service|
      #puts ms.to_s
      name = service["service_name"]
      #puts name
      path = service["service_path"]
      #puts path
      ip = service["service_host"]
      #puts ip
      port = service["service_port"]
      #puts port

      status = is_port_open?(ip, port)
      if status
        puts "Service: #{name}, Path:#{path}, IP: #{ip}, Port: #{port} is " + "connected".color(Colors::GREEN)
        elements_on.push(service)
      else
        # status is false
        puts "Service: #{name}, Path:#{path}, IP: #{ip}, Port: #{port} is " + "disconnected".color(Colors::RED)
		    elements_off.push(service)
      end
    end

    if on
      return elements_on
    elsif off
      return elements_off
    end

  end

  ##
  # TESTINGS MONITORING

  # Description
	#
	def ns_catalogue_poster()
    #.. do something..
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

    #puts uri.request_uri

    #request.set_form_data('code' => token, 'client_id' => @client_id, 'client_secret' => client_secret, 'redirect_uri' => googleauth_url, 'grant_type' => 'authorization_code')
    request.content_type = 'application/json'
    request.body = params
    #puts "BODY", request.body
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
    #.. do something..
    result = Net::HTTP.get(URI.parse('http://apis.t-nova.eu:4011/network-services/12'))
    puts result
    return result
  end

  # Description
	#
  def ns_monitoring_checker()
    #TODO
  end

  # Description
	#
  def nsd_validator_checker()
    #.. do something..
    url = 'http://apis.t-nova.eu:4015/nsds'
    #puts url
    uri = URI.parse(url)
    #puts uri.host
    #puts uri.port

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

  ##
  # STATISTICS MONITORING

  # Description
	#
  def event_collector()
    #.. do something..
  end

  ##
  # LOOP METHODS

end

