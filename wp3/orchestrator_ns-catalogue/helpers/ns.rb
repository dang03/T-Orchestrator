# @see OrchestratorNsCatalogue
class OrchestratorNsCatalogue < Sinatra::Application

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

	def build_http_link(offset, limit)
		link = ''
		# Next link
		next_offset = offset + 1
		next_nss = Ns.paginate(:page => next_offset, :limit => limit)
		link << '<localhost:4011/network-services?offset=' + next_offset.to_s + '&limit=' + limit.to_s + '>; rel="next"' unless next_nss.empty?

		unless offset == 1
			# Previous link
			previous_offset = offset - 1
			previous_nss = Ns.paginate(:page => previous_offset, :limit => limit)
			unless previous_nss.empty?
				link << ', ' unless next_nss.empty?
				link << '<localhost:4011/network-services?offset=' + previous_offset.to_s + '&limit=' + limit.to_s + '>; rel="last"'
			end
		end
		link
	end
end
