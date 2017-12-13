'use strict';

angular.module('tNovaApp')
    .controller('HistoryListController', function ($scope, HistoryService, $filter) {

        var data = HistoryService.query({}, function (result) {
            $scope.dataCollection = data;
        });

        /*
         $scope.history = HistoryService.query();
         var getData = function () {
         return $scope.history;
         };
         
         $scope.$watch("history", function () {
         $scope.tableParams.reload();
         });
         $scope.tableParams = new ngTableParams({
         page: 1, // show first page
         count: 10, // count per page
         data: {},
         sorting: {
         name: 'desc' // initial sorting
         }
         }, {
         total: function () {
         return getData.length;
         }, // length of data
         getData: function ($defer, params) {
         var filteredData = getData();
         var orderedRecentActivity = params.sorting() ? $filter('orderBy')(filteredData, params.orderBy()) : filteredData;
         params.total(orderedRecentActivity.length);
         $defer.resolve(orderedRecentActivity.slice((params.page() - 1) * params.count(), params.page() * params.count()));
         $scope.history = orderedRecentActivity.slice((params.page() - 1) * params.count(), params.page() * params.count());
         $defer.resolve($scope.history);
         
         }, $scope: {$data: {}}
         });*/
    })
    .controller('HistoryCreateController', function ($scope, HistoryService) {
        $scope.history = new HistoryService(); //create new movie instance. Properties will be set via ng-model on UI

        $scope.types = [
                'INFO',
                'ERROR',
                'WARN'
            ];

        $scope.history.type = $scope.types[0]; // info

        $scope.save = function () { //create a new movie. Issues a POST to /api/movies
            $scope.history.content = "Dummy Hist entry";
            $scope.history.$save(function (data) {
                console.log(data);
            });
        };
    });
