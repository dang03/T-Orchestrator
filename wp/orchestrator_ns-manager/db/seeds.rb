require_relative '../models/serviceModel'
require_relative '../helpers/config'

service = { "name" => "nscatalogue", "path" => "/network-services", "host" => "127.0.0.1", "port" => "4011"}
@service = ServiceModel.new(service).save!
service = { "name" => "nsprovisioning", "path" => "/ns-instances", "host" => "127.0.0.1", "port" => "4012"}
@service = ServiceModel.new(service).save!
service = { "name" => "nsmonitoring", "path" => "/ns-monitoring", "host" => "127.0.0.1", "port" => "4014"}
@service = ServiceModel.new(service).save!

#VNF related

service = { "name" => "vnfmanager", "path" => "/vnf-manager", "host" => "193.136.92.205", "port" => "4567"}
@service = ServiceModel.new(service).save!