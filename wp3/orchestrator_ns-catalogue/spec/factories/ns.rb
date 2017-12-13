FactoryGirl.define do
	factory :ns do
		sequence(:_id) { |n| n }
		sequence(:name) { |n| 'NS_' + n.to_s }
		#sequence(:vnf_manager) { |n| 'Manager_' + n.to_s }
		sequence(:nsd) { |n| {test: 'test_' + n.to_s} }
	end
end