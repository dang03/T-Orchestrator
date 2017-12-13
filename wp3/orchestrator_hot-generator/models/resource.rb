class Resource
	attr_reader :name

	def initialize(name, type, properties)
		@name = name
		@type = type
		@properties = properties
	end

	def to_yaml
		properties_not_empty = {}
		@properties.each do |key, value|
			puts "#{key} -> #{value}"
			unless value.nil?
				properties_not_empty[key] = value
			end
			puts properties_not_empty
		end
		{'type' => @type, 'properties' => properties_not_empty}
	end
end
