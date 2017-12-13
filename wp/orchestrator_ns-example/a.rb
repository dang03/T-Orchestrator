#require 'sinatra'
#require 'sinatra/activerecord'

def update_list_of_services()
    require 'net/http'

    result = Net::HTTP.get(URI.parse('http://apis.t-nova.eu/orchestrator/configs/services'))

    #url = URI.parse('http://www.example.com/index.html')
    #req = Net::HTTP::Get.new(url.to_s)
    #res = Net::HTTP.start(url.host, url.port) {|http|
    #http.request(req)
    #}
    puts result.to_s
end


def nsd_validator_checker()
    #.. do something..
    require 'net/http'
    require 'uri'

    url = 'http://apis.t-nova.eu:4015/nsds'
    #puts url
    uri = URI.parse(url)
    puts uri.host
    puts uri.port

    #if version == 'OK'
    #  params = File.read('../config/template_nsd.json')
    #  Net::HTTP.post_form(uri, params)
    #else
    #  params = File.read('../config/bad_nsd.json') #if version == 'BAD'
    #  Net::HTTP.post_form(uri, params)
    #end

    #params = File.read('config/template_nsd.json')
    params = File.read('config/t-nova_nsd.json')
    puts params

    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)

    puts uri.request_uri

    #request.set_form_data('code' => token, 'client_id' => @client_id, 'client_secret' => client_secret, 'redirect_uri' => googleauth_url, 'grant_type' => 'authorization_code')
    request.content_type = 'application/json'
    request.body = params
    puts "BODY", request.body
    response = http.request(request)
    response.code

    puts response.code
end

def ns_catalogue_poster()
  require 'net/http'
  require 'uri'

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

  puts response.code
  return response.code
end

def list_of_services(name=nil)
  require 'json'
  puts name.to_s

  file = File.read('config/ms_ports.json')
  puts file.to_s

  data_hash = JSON.parse(file)

  puts data_hash.to_s

  if name
    data_hash.each do |service|

      if service["service_name"] == name.to_s
        puts service["service_name"]
        return service
      end
    end
    return "Service not found"
  else
    return data_hash
  end
end

def service_stats(servicename, servicestatus)
    #Description: each microservice will have 2 states
    # -Status: UP/DOWN ; Port connection
    # -Health: OK/BAD ; Semantic tests
    #read/create json file to save microservices status
    
    require 'json'
    require 'pp'

    #Should we create a DB or use JSON notation to store stats related to some services
    begin
      file = File.read('config/status.json')
      puts "File located: Reading"
    rescue
      file = File.new('config/status.json', 'w+')
      puts "File unknown: Creating new file"
    end
    
    file_hash = JSON.parse(file)
    #pp file_hash

    done = false

    #file_hash.each { |service|
    for service in file_hash do
      if service['service_name'] == servicename
        service['status'] = servicestatus
        done = true
        puts "SERVICE: #{service} updated"
      end
    end

    if !done
      puts "SERVICE: #{servicename} NOT FOUND"
      file_line = {'service_name' => servicename, 'status' => servicestatus, 'health' => nil}

      file_hash << file_line
      puts "New SERVICE: #{servicename} added"
      #file_hash.add(servicename, servicestatus)
    end

    #}
    file_jsonified = file_hash.to_json
    File.write('config/status.json', file_jsonified)

    #if name
    #  return data_hash[name]
    #else
    #  return data_hash
    #end
    return file_hash    

end

def service_status_pusher(service_name, service_status)
  #TODO: Update status information to NS Manager DB

  # On NS MANAGER side:
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

  url = "http://localhost:4000/configs/services/#{service_name}/status" #<---- CHANGE URI!
  puts url
  uri = URI.parse(url)
  puts uri

  params = service_status #<--------- PASS HERE STATUS VALUE TO CHANGE
  puts params

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Put.new(uri.request_uri) #<--- PUT

  puts uri.request_uri

  #request.set_form_data('code' => token, 'client_id' => @client_id, 'client_secret' => client_secret, 'redirect_uri' => googleauth_url, 'grant_type' => 'authorization_code')
  request.content_type = 'text/plainrn' #<--- Text / Non-type
  request.body = params #<---- JUST TEXT
  puts "BODY: #{request.body}"

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
    #puts "#{e.message}".color(Colors::RED)
    puts "#{e.message}"
  end


end


#update_list_of_services
#nsd_validator_checker
#ns_catalogue_poster
#response = list_of_services("managing")
#puts "RES: #{response}"
#result = service_stats("caching", "UP")
#puts result

result = service_status_pusher("ns_catalogue", "UP")
puts result