class Server < Resource
	def initialize(resource_name, admin_pass: nil, availability_zone: nil, block_device_mapping: nil, config_drive: nil, diskConfig: nil, flavor: nil, flavor_update_policy: nil, image: nil, image_update_policy: nil, key_name: nil, metadata: nil, name: nil, networks: nil, personality: nil, reservation_id: nil, scheduler_hints: nil, security_groups: nil, software_config_transport: nil, user_data: nil, user_data_format: nil)
		type = 'OS::Nova::Server'
		properties = {'admin_pass' => admin_pass, 'availability_zone' => availability_zone, 'block_device_mapping' => block_device_mapping, 'config_drive' => config_drive, 'diskConfig' => diskConfig, 'flavor' => flavor, 'flavor_update_policy' => flavor_update_policy, 'image' => image, 'image_update_policy' => image_update_policy, 'key_name' => key_name, 'metadata' => metadata, 'name' => name, 'networks' => networks, 'personality' => personality, 'reservation_id' => reservation_id, 'scheduler_hints' => scheduler_hints, 'security_groups' => security_groups, 'software_config_transport' => software_config_transport, 'user_data' => user_data, user_data_format => user_data_format}
		super(resource_name, type, properties)
	end
end
