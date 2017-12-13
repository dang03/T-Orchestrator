class Router < Resource
	def initialize(resource_name, admin_state_up: nil, external_gateway_info: nil, name: nil, value_specs: nil, l3_agent_id: nil)
		@type = 'OS::Neutron::Router'
		@properties = {admin_state_up: admin_state_up, external_gateway_info: external_gateway_info, name: name, value_specs: value_specs, l3_agent_id: l3_agent_id}
		super(resource_name, @type, @properties)
	end
end
