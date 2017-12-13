# @see OrchestratorNsMonitoring
class OrchestratorNsMonitoring < Sinatra::Application

	## Monitoring - GET
	get '/ns-monitoring/:instance_id' do
		t = []
		@db.execute("SELECT metricName, date, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}'").fetch { |row| t.push( row.to_hash ) }
		return t.to_json
	end
	
	get '/ns-monitoring/:instance_id/:metric' do
		t = []
		@db.execute("SELECT metricName, date, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metric='#{params[:metric].to_s}' LIMIT 100").fetch { |row| t.push(row.to_hash) }
		return t.to_json
	end
	
	get '/ns-monitoring/:instance_id/:metric/:start/:end' do
		t = []
		@db.execute("SELECT metricName, date, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metric='#{params[:metric].to_s}' AND timestamp >= #{params[:start]} AND timestamp <= #{params[:end]}").fetch { |row| t.push(row.to_hash) }
		return t.to_json
	end
	
	get '/ns-monitoring/:instance_id/:metric/last10' do
		t = []
		@db.execute("SELECT metricName, date, value FROM nsmonitoring WHERE instanceid='#{params[:instance_id].to_s}' AND metric='#{params[:metric].to_s}' LIMIT 100").fetch { |row| t.push(row.to_hash) }
		return t.to_json
	end
	
	##Monitoring - POST
	post '/ns-monitoring/:instance_id' do
		@json = JSON.parse(request.body.read)
		@json.each do |item|
			@db.execute("INSERT INTO nsmonitoring (instanceid, date, metricname, value) VALUES ('#{params[:instance_id].to_s}', #{Time.new.to_i}, '#{item[0].to_s}', '#{item[1].to_s}')")
		end
	end
end

