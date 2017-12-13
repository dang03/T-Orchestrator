class VNFMonitoringData
	attr_accessor :parameter_id, :value, :timestamp
	def initialize(params)
		@parameter_id = params["parameter_id"].to_i
		@value = params["value"]
		@timestamp = params["timestamp"]
	end
	
	
end
