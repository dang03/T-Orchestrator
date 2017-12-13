class Port < Resource
	def initialize(resource_name, admin_state_up: nil, allowed_address_pairs: nil, device_id: nil, device_owner: nil, fixed_ips: nil, mac_address: nil, name: nil, network: nil, replacement_policy: nil, security_groups: nil, value_specs: nil)
		@type = 'OS::Neutron::Port'
		@properties = {admin_state_up: admin_state_up, allowed_address_pairs: allowed_address_pairs, device_id: device_id, device_owner: device_owner, fixed_ips: fixed_ips, mac_address: mac_address, name: name, network: network, replacement_policy: replacement_policy, security_groups: security_groups, value_specs: value_specs}
		super(resource_name, @type, @properties)
	end
end
