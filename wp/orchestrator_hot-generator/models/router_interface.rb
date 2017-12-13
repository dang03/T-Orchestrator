class RouterInterface < Resource
	def initialize(resource_name, router: nil, subnet: nil, port_id: nil, router_id: nil)
		@type = 'OS::Neutron::RouterInterface'
		@properties = {router: router, subnet: subnet, port_id: port_id, router_id: router_id}
		super(resource_name, @type, @properties)
	end
end
