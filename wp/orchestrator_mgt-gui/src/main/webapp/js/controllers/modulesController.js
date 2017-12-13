'use strict';

angular.module('tNovaApp')
    .controller('modulesController', function ($scope, $routeParams, $filter, msService, $interval, $modal) {
        var promise = $interval(function () {
            msService.list($routeParams.id).then(function (data) {
                if (data === undefined) return;
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
            msService.delete(id).then(function (data) {});
            this.$hide();
        };

        $scope.$on("$destroy", function () {
            if (promise) {
                $interval.cancel(promise);
            }
        });

        $scope.registerService = function (service) {
            console.log("register service");
            console.log(service);
            msService.post(JSON.stringify(service)).then(function (data) {});
        };
    });
