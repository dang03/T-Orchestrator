class VnfdToHot
	def initialize(description)
		@hot = Hot.new(description)
		@name = ''
	end

	def build(name, vnfd)
		@name = name
#		@public_network = nil

		#deployment_information = vnfd['deployment_flavour'].detect{|flavour| flavour['id'] == 'vnfflavourid1'}
		vnfd['vdu'].each do |vdu|
			flavour_name = create_flavour(vdu)
			create_server(vdu, flavour_name)
		end




#		deployment_information = vnfd['deployment_flavour']
#		constituent_vdus = deployment_information['constituent_vdu']
#		constituent_vdus.each do |constituent_vdu|
#			vdu = vnfd['vdus'].detect{|vdu| vdu['id'] == constituent_vdu['vdu_reference']}
#			vnfcs = vdu['vnfc'].detect{|value| value['id'] == constituent_vdu['constituent_vnfc']}
#
#			ports = create_ports(vnfcs, vdu)
#			create_server(vdu, ports)
#		end

		@hot.to_yaml

=begin
		hash = {
			'heat_template_version' => '2013-05-23',
			'description' => 'teste',
			'resources' => {
				'private_net' => {
					'type' => 'OS::Neutron::Net',
					'properties' => {
						'name' => 'teste_net'
					}
				},
				'private_subnet' => {
					'type' => 'OS::Neutron::Subnet',
					'properties' => {
						'network_id' => '{ get_resource: private_net }',
						'cidr' => '192.168.166.0/24',
						'gateway_ip' => '192.168.166.1',
						'allocation_pools' => [
							{
								'start' => '192.168.166.100',
								'end' => '192.168.166.200'
							}
						]
					}
				}
			}
		}
		hash.to_yaml
=end
	end

	def create_flavour(vdu)
		name = get_resource_name
		flavour = Flavour.new(name, vdu['storage_requirements']['size'], vdu['virtual_memory_resource_element'] ,vdu['computation_requirement']['vcpus'])
		@hot.add_resource(flavour)
		name
	end

	def create_server(vdu, flavour_name)
		name = get_resource_name
		teste = {'teste' => {'get_resource' => flavour_name } }
		#puts teste
#		flavour = '{get_resource: ' + flavour_name + '}'
		server = Server.new(name, image: vdu['vm_image'], flavor: "{get_resource: #{flavour_name}}")

		@hot.add_resource(server)
	end

	def get_resource_name
		@name + '_' + @hot.resources_list.length.to_s unless @name.empty?
	end

end