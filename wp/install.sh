#!/bin/bash

RAILS_ENV=development

cd orchestrator_ns-catalogue
bundle install
cd ../

echo "\n ------ Validator  ------  \n"
cd orchestrator_nsd-validator
bundle install
cd ../

echo "\n ------ instance-repository  ------  \n"
cd orchestrator_ns-instance-repository
bundle install
RAILS_ENV=$RAILS_ENV rake db:create
RAILS_ENV=$RAILS_ENV rake db:migrate
cd ../

echo "\n ------ monitoring  ------  \n"
cd orchestrator_ns-monitoring
bundle install
RAILS_ENV=$RAILS_ENV rake db:create
RAILS_ENV=$RAILS_ENV rake db:migrate
cd ../

echo "\n ------ monitoring-repository  ------  \n"
cd orchestrator_ns-monitoring-repository
bundle install
cd ../

echo "\n ------ provisioner  ------  \n"
cd orchestrator_ns-provisioner
bundle install
cd ../

echo "\n ------ manager  ------  \n"
cd orchestrator_ns-manager
bundle install
RAILS_ENV=$RAILS_ENV rake db:create
RAILS_ENV=$RAILS_ENV rake db:migrate
cd ../

#echo "\n ------ manager - monitoring  ------  \n"
#cd orchestrator_ns-manager/default/monitoring/
#bundle install
#cd ../

echo "\n ------ VNF Catalogue  ------  \n"
cd orchestrator_vnf-catalogue
bundle install
cd ../

echo "\n ------ VNFD Validator  ------  \n"
cd orchestrator_vnfd-validator
bundle install
cd ../

echo "\n ------ VNF Manager  ------  \n"
cd orchestrator_vnf-manager
bundle install
cd ../