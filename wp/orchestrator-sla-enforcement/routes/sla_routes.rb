# @see OrchestratorSlaEnforcement
class OrchestratorSlaEnforcement < Sinatra::Application

  before do
    headers 'Content-Type' => 'application/json'

    pass if request.path_info == '/'
    # Validate every request with Gatekeeper
    @client_token = request.env['HTTP_X_AUTH_TOKEN']
    begin
      response = RestClient.get "#{settings.gatekeeper}/token/validate/#{@client_token}", 'X-Auth-Service-Key' => settings.service_key, :content_type => :json
    rescue => e
      logger.error e.response
      halt e.response.code, e.response.body
    end
  end

  # @method get_root
  # @overload get '/'
  #       Get all available interfaces
  # Get all interfaces
  get '/' do
    return 200, interfaces_list.to_json
  end

  # @method post_sla-enforcement_slas
  # @overload post '/sla-enforcement/slas'
  #   Post a SLA in JSON format
  #   @param [JSON] SLA in JSON format
  # Post a SLA
  post '/sla-enforcement/slas' do
    # Return if content-type is invalid
    unless request.content_type == 'application/json'
      body = 'Content-type must be "application/json".\n'
      headers 'Content-Length' => body.length.to_s
      return [ 415, headers, [body]]
    end

    # Return if request body is invalid
    request_body = request.body.read
    if request_body.to_s.empty?
      body = "SLA definition can not be empty.\n"
      headers 'Content-Length' => body.length.to_s
      return [ 400, headers, [body]]
    end

    # Parse JSON
    unless (json = JSON.parse request_body)
      body = "Could not create parse JSON with #{request_body}.\n"
      headers 'Content-Length' => body.length.to_s
      return [ 422, headers, [body]]
    end

    # Create SLA object
    unless (@sla = Sla.new(nsi_id: json['nsi_id'].to_i))
      body = "Could not create SLA from #{request_body}.\n"
      headers 'Content-Length' => body.length.to_s
      return [ 422, headers, [body]]
    end

    parameters = []
    json["parameters"].each do |parameter|
      violations = []
      parameter['violations'].each do |violation|
        violations.push(Violation.new(breaches_count: violation['breaches_count'].to_i, interval: violation['interval'].to_i))
      end
      parameters.push(Parameter.new(name: parameter['name'], minimum: parameter['minimum'].to_f, maximum: parameter['maximum'].to_f, threshold: parameter['threshold'], violations: violations))

      #TODO: calculate values
    end
    @sla.parameters = parameters

    #TODO: deal with transactions
    #http://stackoverflow.com/questions/7965949/best-practice-for-bulk-update-in-controller
#    def update_bulk
#      @posts = Post.where(:id => params[:ids])
    #wrap in a transaction to avoid partial updates (and move to the model in any case)
#      if @posts.all? { |post| post.update_attributes(params[:post]) }
#        redirect_to(posts_url)
#      else
#        redirect_to(:back)
#      end
#    end

#    @sla.parameters.each do |parameter|
#      unless parameter.save
#        body = "Parameter #{parameter.to_json} of the SLA #{@sla.to_json} could not be saved.\n"
#        headers 'Content-Length' => body.length.to_s
#        halt 401, headers, body
#      end
#    end

    # Save object to database
    unless @sla.save
      body = "The SLA #{@sla.to_json} could not be saved.\n"
      headers 'Content-Length' => body.length.to_s
      return [ 401, headers, [body]]
    end

    body = "The SLA #{@sla.to_json} has been successfuly created.\n"
    headers 'Content-Length' => body.length.to_s
    headers 'Location' => "/sla-enforcement/slas/#{@sla.id}"
    halt 201, headers, body'/sla-enforcement/slas'
  end

  # @method put_sla-enforcement_slas_id
  # @overload post '/sla-enforcement/slas/:id'
  #   Update a SLA in JSON format
  #   @param [JSON] SLA in JSON format
  # Update a SLA
  put '/sla-enforcement/slas/:id' do
    return 415 unless request.content_type == 'application/json'
    @sla = JSON.parse request.body.read

    #TODO when authentication is ready
#    return 401 unless validate(@sla)

    return 404 unless @sla

    #don't forget to subscribe from the NS Monitoring module
    #TODO

    { status: 200 }.to_json

  end

  # @method delete_sla-enforcement_slas_id
  # @overload delete '/sla-enforcement/slas/:id'
  #   Delete a SLA by its ID
  #   @param [Integer] id SLA ID
  # Delete a SLA
  delete '/sla-enforcement/slas/:id' do
    sla = Sla.destroy(params[:id])
    return [ 404, headers, []] unless sla

    #TODO
    #ubsubscribe from the NS Monitoring module
    body = "The SLA #{sla.to_json} has been successfuly deleted.\n"
    headers 'Content-Length' => body.length.to_s
    [ 200, headers, [body]]
  end

  # @method get_sla-enforcement_slas
  # @overload get '/sla-enforcement/slas'
  #   Returns a list of SLAs
  # List all SLAs
  get '/sla-enforcement/slas' do
    params[:offset] ||= 1
    params[:limit] ||= 2

    # Only accept positive numbers
    params[:offset] = 1 if params[:offset].to_i < 1
    params[:limit] = 2 if params[:limit].to_i < 1

    # Get paginated list
    @slas = Sla.paginate(:page => params[:offset], :per_page => params[:limit])

    halt 404, headers, '' unless @slas

    # Build HTTP Link Header
    headers['Link'] = build_http_link(params[:offset].to_i, params[:limit])

    headers 'Content-Length' => @slas.to_json.length.to_s
    [ 200, headers, [@slas.to_json]]
  end

  # @method get_sla-enforcement_slas_id
  # @overload get '/sla-enforcement/slas/:id'
  #   Show a SLA
  #   @param [Integer] id SLA ID
  # Show a SLA
  get '/sla-enforcement/slas/:id' do
    @sla = Sla.find_by_id(params[:id])
    return [ 404, headers, []] unless @sla

    headers 'Content-Length' => @sla.to_json.length.to_s
    [ 200, headers, [@sla.to_json]]
  end
end