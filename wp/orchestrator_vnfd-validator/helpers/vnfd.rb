# @see OrchestratorVnfdValidator
class OrchestratorVnfdValidator < Sinatra::Application

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

	# Checks if a parsed JSON message is a valid VNFD
	#
	# @param [Hash] vnfd the JSON message parsed
	# @return [Hash, nil] if the JSON message is a valid VNFD
	# @return [Hash, String] if the JSON message is an invalid VNFD
	def validate_json_vnfd(vnfd)
		# Read VNFD json schema
		json_schema = File.read(settings.json_schema)
		begin
			JSON::Validator.validate!(json_schema, vnfd)
		rescue JSON::Schema::ValidationError
			logger.error "JSON validation: #{$!.message}"
			return vnfd, $!.message + "\n"
		end

		return vnfd, nil
		#errors = JSON::Validator.fully_validate(json_schema, vnfd)
	end

	# Checks if a XML message is valid
	#
	# @param [XML] message some XML message
	# @return [Hash, nil] if the parsed message is a valid XML
	# @return [Hash, String] if the parsed message is an invalid XML
	def parse_xml(message)
		# Check XML message format
		begin
			parsed_message = Nokogiri::XML(message) { |config| config.strict }
		rescue Nokogiri::XML::SyntaxError => e
			logger.error "XML parsing: #{e}"
			return message, e
		end

		return parsed_message, nil
	end

	# Checks if a parsed XML message is a valid VNFD
	#
	# @param [Hash] vnfd the XML message parsed
	# @return [Hash, nil] if the XML message is a valid VNFD
	# @return [Hash, String] if the XML message is an invalid VNFD
	def validate_xml_vnfd(vnfd)
		# Read VNFD xsd schema
		begin
			xsd = Nokogiri::XML::Schema(File.read(settings.xml_schema))
		rescue Nokogiri::XML::SyntaxError => e
			errors = []
			e.each do |error|
				logger.error "XSD parsing: #{error.message}"
				errors.push(error.message)
			end
			return vnfd, errors
		end

		# Validate received XML message against VNFD schema
		errors = []
		xsd.validate(vnfd).each do |error|
			logger.error "XSD validation: #{e}"
			errors.push(error.message)
		end
		if errors.empty?
			return vnfd, nil
		else
			return vnfd, errors
		end
	end

	# Method which lists all available interfaces
	#
	# @return [Array] an array of hashes containing all interfaces
	def interfaces_list
		[
			{
				'uri' => '/',
				'method' => 'GET',
				'purpose' => 'REST API Structure and Capability Discovery'
			},
			{
				'uri' => '/vnfds',
				'method' => 'POST',
				'purpose' => 'Validate a VNFD'
			}
		]
	end
end
