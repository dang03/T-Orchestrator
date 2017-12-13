# @see OrchestratorHotGenerator
class OrchestratorHotGenerator < Sinatra::Application

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

	# Generate a HOT template
	#
	# @param [JSON] vnfd some vnfd
	# @return [Hash] the generated hot template
	def generate_hot_template(name, vnfd)
		hot_obj = VnfdToHot.new(vnfd['description'])

		hot_obj.build(name, vnfd)
	end

	def save_hot2file(hot)
		File.open('teste.yml', 'w') { |file| file.write(hot) }
		File.open('teste.yml', 'r+') do |file|
			file.each_line do |line|
				if line.include? 'get_resource'
					file.seek(-line.length, IO::SEEK_CUR)
					file.puts line.tr!('"', ' ')
				end
			end
		end
	end
end
