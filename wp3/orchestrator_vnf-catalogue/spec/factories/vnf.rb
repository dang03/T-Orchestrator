FactoryGirl.define do
	factory :vnf do
		sequence(:_id) { |n| n }
		sequence(:name) { |n| 'Firewall_' + n.to_s }
		sequence(:vnf_manager) { |n| 'Manager_' + n.to_s }
		sequence(:vnfd) { |n| {test: 'test_' + n.to_s} }
	end
end