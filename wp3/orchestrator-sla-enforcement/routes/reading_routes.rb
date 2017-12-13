class OrchestratorSlaEnforcement < Sinatra::Application

  post '/sla-enforcement/readings' do
    unless request.content_type == 'application/json'
      body = 'Content-type must be "application/json"'
      headers 'Content-Length' => body.length.to_s
      return [ 415, headers, [body]]
    end

    request_body = request.body.read

    json = JSON.parse(request_body)

    unless json.has_key?("nsi_id") && json.has_key?("parameter_id") && json.has_key?("value")
      body = "Invalid request: #{request_body}.\n"
      headers 'Content-Length' => body.length.to_s
      return [ 401, headers, [body]]
    end

		@reading = Reading.new(json)

    unless @reading.valid?
      body = "Invalid reading: #{@reading.to_json}"
      headers 'Content-Length' => body.length.to_s
      return [ 401, headers, [body]]
    end

    @sla = Sla.find_by_nsi_id @reading.nsi_id
    unless @sla
      body = "Could not find an SLA for NS Instance ID #{@reading.nsi_id}"
      headers 'Content-Length' => body.length.to_s
      return [ 404, headers, [body]]
    end

    unless @sla.includes? @reading.parameter_id
      body = "It seems that parameter ID #{@reading.parameter_id} is not part of the SLA for NS Instance ID #{@reading.nsi_id}"
      headers 'Content-Length' => body.length.to_s
      halt [ 404, headers, [body]]
    end

    @sla_breach = @sla.process_reading(@reading)
    if @sla_breach
      body = @sla_breach.to_s
      headers 'Content-Length' => body.length.to_s
      [ 201, headers, [body]]
    else
      body = "It seems that we could not process parameter #{@reading.to_json}.\n"
      headers 'Content-Length' => body.length.to_s
      [ 422, headers, [body]]
    end
  end
end