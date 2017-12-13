#class Net < Resource
#	def initialize(resource_name, name: nil, admin_state_up: nil, dhcp_agent_ids: nil, shared: nil, tenant_id: nil, value_specs: nil)
#		@type = 'OS::Neutron::Net'
#		@properties = {name: name, admin_state_up: admin_state_up, dhcp_agent_ids: dhcp_agent_ids, shared: shared, tenant_id: tenant_id, value_specs: value_specs}
#		super(resource_name, @type, @properties)
#	end
#end
