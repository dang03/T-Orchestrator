class Flavour < Resource
	def initialize(resource_name, disk, ram, vcpus)
		type = 'OS::Nova::Flavor'
		properties = {'disk' => disk, 'ram' => ram, 'vcpus' => vcpus}
		super(resource_name, type, properties)
	end
end