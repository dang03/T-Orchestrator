class VnfInstance < ActiveRecord::Base
	has_many :parameters
	
	def as_json(options={})
		super(
			:include => {
				:parameters => {
					:except => [:vnf_instance_id, :formula, :monitoring_metric_id]
				}
			},
			:except => [:id, :vnf_id, :monitoring_metric_id]
		)
	end
end
