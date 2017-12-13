class FloatingIp < Resource
	def initialize(resource_name, fixed_ip_address: nil, port_id: nil, value_specs: nil, floating_network: nil)
		@type = 'OS::Neutron::FloatingIP'
		@properties = {floating_network: floating_network, fixed_ip_address: fixed_ip_address, port_id: port_id, value_specs: value_specs}
		super(resource_name, @type, @properties)
	end
end
