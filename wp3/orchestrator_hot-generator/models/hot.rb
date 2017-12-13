class Hot
	attr_reader :resources_list

	def initialize(description)
		@version = '2014-10-16'
		@description = description
		@resources_list = []
	end

	def add_resource(resource)
		@resources_list.push(resource)
	end

	def to_yaml
		resources = {}
		@resources_list.each do |resource|
			resources[resource.name] = resource.to_yaml
		end
		{'heat_template_version' => @version, 'description' => @description, 'resources' => resources}.to_yaml
	end
end
