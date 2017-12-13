class Vnf
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Pagination

	field :_id, type: String, default: ->{id}
	field :name, type: String
	field :vnf_manager, type: String
	field :vnfd, type: Hash
end