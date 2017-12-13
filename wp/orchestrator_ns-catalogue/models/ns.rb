class Ns
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Pagination

	field :_id, type: String, default: ->{id}
	field :name, type: String
	#field :vnf_manager, type: String
	field :nsd, type: Hash
	
	
	#has_many :monitoring_parameters, :dependent => :destroy
	#has_many :service_deployment_flavour, :dependent => :destroy
	##has_many :sla_specification, :dependent => :destroy
	#has_many :connection_points, :dependent => :destroy
	##has_many :assurance_parameters, :dependent => :destroy
	#
	#validates :ns_id, presence: true
	#validates_uniqueness_of :ns_id, scope: [:vendor, :version]
	#
	#serialize :vnfs
	#serialize :vnffgd
	#serialize :vnf_dependencies
	#serialize :vld
	#serialize :lifecycle_events

end