'use strict';

angular.module('tNovaApp')
    .controller('nsController', function ($scope, $routeParams, $filter, nsService, $interval, $modal) {

        var promise = $interval(function () {
            nsService.list($routeParams.id).then(function (data) {
                $scope.data = data;
                $scope.dataCollection = data;
            });
        }, defaultTimer);

        $scope.deleteDialog = function (id) {
            $scope.itemToDeleteId = id;
            $modal({
                title: "Are you sure you want to delete this item?",
                template: "partials/t-nova/modals/delete.html",
                show: true,
                scope: $scope,
            });
        };
        $scope.deleteItem = function (id) {
            nsService.delete(id).then(function (data) {});
            this.$hide();
        };

        $scope.showDescriptor = function (id) {
            nsService.get(id).then(function (data) {
                $scope.jsonObj = data;
                console.log(data);
                $modal({
                    title: "Network Service Descriptor - " + data.name,
                    content: JSON.stringify(data, undefined, 4),
                    template: "partials/t-nova/modals/descriptors.html",
                    show: true,
                    scope: $scope,
                });
            });
        };
        $scope.$on("$destroy", function () {
            if (promise) {
                $interval.cancel(promise);
            }
        });

        $scope.instantiate = function (id) {
            //instantiate a service and redirect to instance view
            window.location = "#!/nsInstances/" + id;
        };
        $scope.terminate = function (id) {
            console.log("Terminate Network Service");
        };
    })
    .controller('nsInstancesController', function ($scope, $location, $routeParams, $filter, nsService, vnfService, instanceService, $interval) {
        var promise;
        if ($routeParams.id) {
            console.log("instantitate service using the id");
            //instanceService.create();
            var instance = {};
            instance.ns_id = parseInt($routeParams.id);
            instanceService.create("ns", instance).then(function (data) {
                //create an instance for each vnf
                nsService.get($routeParams.id).then(function (service) {
                    console.log(service);
                    service.vnf.forEach(function (entry) { //id of each vnf contained in the ns
                        var instance = {};
                        instance.status = 0;
                        instance.vnf_id = parseInt(entry);
                        instanceService.create("vnf", instance).then(function (data) {});
                    });
                });
            });
        }

        $scope.go = function (hash) {
            $location.path(hash);
        };

        $scope.data = [];
        $scope.updateInstanceList = function () {
            promise = $interval(function () {
                instanceService.list("ns").then(function (data) {
                    $scope.data = data;
                    $scope.dataCollection = data;
                });
            }, defaultTimer);
        };


        $scope.stop = function (instance) { //change status in the repo
            if (instance.status === 3) instance.status = 0;
            else if (instance.status === 0) instance.status = 3;
            instanceService.update("ns", instance.id, instance).then(function (data) {});
        };
        $scope.delete = function (id) {
            instanceService.remove("ns", id).then(function (data) {});
        };

        $scope.updateInstanceList();
        $scope.$on("$destroy", function () {
            if (promise) {
                $interval.cancel(promise);
            }
        });
    })
    .controller('nsMonitoringController', function ($scope, $routeParams, $filter, mDataService, $interval, instanceService) {
        var promise;
        $scope.instanceId = $routeParams.id;
        if ($routeParams.id) {
            instanceService.get("ns", $routeParams.id).then(function (instance) {
                $scope.instanceId = instance.instance_id;
            });
        }

        $scope.rtt_metric = [];
        $scope.packet_loss = [];
        $scope.response_time = [];

        $scope.ram_consumption = [];
        $scope.availability = [];

        $scope.rtt_metric.push();

        mDataService.get($routeParams.id).then(function (data) {
            $scope.mData = data;
        });
        $scope.mem_percent = 40;
        var promise_table = $interval(function () {
            $scope.cpu_percent = Math.floor((Math.random() * $scope.cpu_percent) + 20);
            var init = Math.floor((Math.random() * 2));
            init *= Math.floor(Math.random() * 2) == 1 ? 1 : -1;
            $scope.mem_percent = $scope.mem_percent + init;
            var rtt = Math.floor((Math.random() * 100) + 1); //ms

            var second = vis.moment();
            $scope.rtt_metric.push({
                x: second,
                y: Math.floor((Math.random() * 100) + 1)
            });
            $scope.packet_loss.push({
                x: second,
                y: Math.floor((Math.random() * 100) + 1)
            });
            $scope.response_time.push({
                x: second,
                y: Math.floor((Math.random() * 100) + 1)
            });

            $scope.ram_consumption.push({
                x: second,
                y: Math.floor((Math.random() * 100) + 1)
            });

            $scope.availability.push({
                x: second,
                y: 100
            });

            var packet_loss = Math.floor((Math.random() * 100) + 1); //%
            var response_time = Math.floor((Math.random() * 100) + 1); //ms
            $scope.tableData = [
                /*{
                    type: "Round Trip Time",
                    value: $scope.rtt_metric[$scope.rtt_metric.length - 1].y,
                    valueType: "ms"
                },
                {
                    type: "Packet loss",
                    value: $scope.packet_loss[$scope.packet_loss.length - 1].y,
                    valueType: "%"
                },
                {
                    type: "Response time",
                    value: $scope.response_time[$scope.response_time.length - 1].y,
                    valueType: "ms"
                }*/
                {
                    type: "Ram Consumption",
                    value: $scope.ram_consumption[$scope.ram_consumption.length - 1].y,
                    valueType: "MB"
                },
                {
                    type: "Availability",
                    value: $scope.availability[$scope.availability.length - 1].y,
                    valueType: "%"
                }
            ];
        }, defaultTimer);
        $scope.options = {

        };

        $scope.showGraph = function (type) {
            $interval.cancel(promise);
            $scope.graph_name = type;
            $scope.monitoringData.clear();
            promise = $interval(function () {
                if (type == "Round Trip Time") $scope.data = $scope.rtt_metric;
                if (type == "Packet loss") $scope.data = $scope.packet_loss;
                if (type == "Response time") $scope.data = $scope.response_time;
                if (type == "Ram Consumption") $scope.data = $scope.ram_consumption;
                if (type == "Availability") $scope.data = $scope.availability;
                var second = $scope.monitoringData.length + 1;
                var metric1 = Math.round(Math.random() * 100);
                $scope.monitoringData.add($scope.data[$scope.data.length - 1]);
            }, 2000);
        };

        $scope.graph_name = "";
        $scope.monitoringData = new vis.DataSet()

        $scope.$on("$destroy", function () {
            if (promise) {
                $interval.cancel(promise);
            }
            if (promise_table) {
                $interval.cancel(promise_table);
            }
        });
    });
