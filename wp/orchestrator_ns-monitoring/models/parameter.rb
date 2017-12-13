class Parameter  < ActiveRecord::Base
	belongs_to :monitoring_metric
	belongs_to :vnf_instance
end
