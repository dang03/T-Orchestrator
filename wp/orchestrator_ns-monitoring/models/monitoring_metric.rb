class MonitoringMetric < ActiveRecord::Base
	has_many :vnf_instances
	has_many :parameters
	
	def as_json(options={})
		super(
			:include => {
				:vnf_instances => {
					:include => {
						:parameters => {
							:except => [:vnf_instance_id, :formula, :monitoring_metric_id]
						}
					},
					:except => [:monitoring_metric_id]
				},
				:parameters => {
					:except => [:monitoring_metric_id, :unit, :vnf_instance_id]
				}
			},
			:except => :id
		)
	end
	
end
