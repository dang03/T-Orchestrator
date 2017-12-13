class Violation < ActiveRecord::Base
  belongs_to :parameter
end

#"assurance_parameters": [
#     /* the values are calculated based on the values of the VNF selected flavour */
#     {
#       "param-id": "availability",
#       "value" : "GT(min(vnfs[1].availability, vnfs[2].availability))",
#       "violation": {
#       "breaches_count": 5,
#       "interval": 120,
#       "penalty": "not included, as they're not relevant to the Orchestrator"
#     },
#     {
#       "param-id": "ram-consumption",
#       "value" : "LT(add(vnfs[1].memory-consumption, vnfs[2].memory-consumption, 100))", /* allow 100MB extra over the combined consumption by the VNFs */
#       "violation": {
#       "breaches_count": 5,
#       "interval": 120,
#       "penalty": "not included, as they're not relevant to the Orchrstrator"
#     }
#   ],
