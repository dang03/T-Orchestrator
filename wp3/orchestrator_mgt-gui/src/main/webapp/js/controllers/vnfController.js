'use strict';

angular.module('tNovaApp')
    .controller('vnfController', function ($scope, $routeParams, $filter, vnfService, $interval, $modal) {

        var promise = $interval(function () {
            vnfService.list($routeParams.id).then(function (data) {
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
            vnfService.delete(id).then(function (data) {});
            this.$hide();
        };

        $scope.showDescriptor = function (id) {
            vnfService.get(id).then(function (data) {
                $scope.jsonObj = data;
                $modal({
                    title: "Virtual Network Function Descriptor - " + data.name,
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
            window.location = "#!/vnfInstances/" + id;
        };
        $scope.terminate = function (id) {
            console.log("Terminate Network Service");
        };
    })
    .controller('vnfInstancesController', function ($scope, $location, $filter, instanceService, $interval) {
        var promise;
        $scope.go = function (hash) {
            $location.path(hash);
        };

        $scope.data = [];
        $scope.updateInstanceList = function () {
            promise = $interval(function () {
                instanceService.list("vnf").then(function (data) {
                    $scope.data = data;
                    $scope.dataCollection = data;
                });
            }, defaultTimer);
        };

        $scope.stop = function (instance) { //change status in the repo
            if (instance.status === 3) instance.status = 0;
            else if (instance.status === 0) instance.status = 3;
            instanceService.update("vnf", instance.id, instance).then(function (data) {});
        };
        $scope.delete = function (id) {
            instanceService.remove("vnf", id).then(function (data) {});
        };

        $scope.updateInstanceList();
        $scope.$on("$destroy", function () {
            if (promise) {
                $interval.cancel(promise);
            }
        });
    })
    .controller('vnfMonitoringController', function ($scope, $routeParams, $filter, mDataService, $interval, instanceService) {
        var promise;
        $scope.instanceId = $routeParams.id;
        if ($routeParams.id) {
            instanceService.get("vnf", $routeParams.id).then(function (instance) {
                $scope.instanceId = instance.instance_id;
            });
        }

        $scope.rtt_metric = [];
        $scope.packet_loss = [];
        $scope.response_time = [];
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

            var second; // = $scope.rtt_metric[$scope.rtt_metric.length-1].second +1;
            second = vis.moment();
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
            var packet_loss = Math.floor((Math.random() * 100) + 1); //%
            var response_time = Math.floor((Math.random() * 100) + 1); //ms
            $scope.tableData = [
                {
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
                }
            ];
        }, 2000);
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
