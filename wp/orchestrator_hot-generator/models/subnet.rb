class Subnet < Resource
	def initialize(resource_name, allocation_pools: nil, cidr: nil, dns_nameservers: nil, enable_dhcp: nil, gateway_ip: nil, host_routes: nil, ip_version: nil, name: nil, network: nil, tenant_id: nil, value_specs: nil)
		@type = 'OS::Neutron::Subnet'
		@properties = {'allocation_pools' => allocation_pools, 'cidr' => cidr, 'dns_nameservers' => dns_nameservers, 'enable_dhcp' => enable_dhcp, 'gateway_ip' => gateway_ip, 'host_routes' => host_routes, 'ip_version' => ip_version, 'name' => name, 'network' => network, 'tenant_id' => tenant_id, 'value_specs' => value_specs}
		super(resource_name, @type, @properties)
	end
end
