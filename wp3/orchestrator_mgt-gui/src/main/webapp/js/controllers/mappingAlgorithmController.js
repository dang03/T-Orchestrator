'use strict';

angular.module('tNovaApp')
        .controller('mappingAlgorithmController', function ($scope) {
            $scope.monitoringData = [
                {x: new Date("2015", "01", "11", "14", "50", "55"), y: 14, group:0},
                {x: new Date("2015", "01", "12", "14", "50", "55"), y: 25, group:0},
                {x: new Date("2015", "01", "13", "14", "50", "55"), y: 30, group:0},
                {x: new Date("2015", "01", "14", "14", "50", "55"), y: 25, group:0},
                {x: new Date("2015", "01", "15", "14", "50", "55"), y: 15, group:0},
                {x: new Date("2015", "01", "16", "14", "50", "55"), y: 30, group:0},
                {x: new Date("2015", "01", "11", "14", "50", "55"), y: 12, group:1},
                {x: new Date("2015", "01", "12", "14", "50", "55"), y: 15, group:1},
                {x: new Date("2015", "01", "13", "14", "50", "55"), y: 19, group:1},
                {x: new Date("2015", "01", "14", "14", "50", "55"), y: 14, group:1},
                {x: new Date("2015", "01", "15", "14", "50", "55"), y: 5, group:1},
                {x: new Date("2015", "01", "16", "14", "50", "55"), y: 12, group:1},
                {x: new Date("2015", "01", "11", "14", "50", "55"), y: 2, group:2},
                {x: new Date("2015", "01", "12", "14", "50", "55"), y: 13, group:2},
                {x: new Date("2015", "01", "13", "14", "50", "55"), y: 15, group:2},
                {x: new Date("2015", "01", "14", "14", "50", "55"), y: 10, group:2},
                {x: new Date("2015", "01", "15", "14", "50", "55"), y: 10, group:2},
                {x: new Date("2015", "01", "16", "14", "50", "55"), y: 18, group:2}
            ];
    
            $scope.scatterData = [];
            var time = new Date('2014-06-11').valueOf();
            for (var i = 0; i < 32; i++) {
                var rand = Math.floor(Math.random() * 30000);
                time = time + rand;
                $scope.scatterData.push({x: time, y: 30 + (Math.random() * 80), group: 0});
            }
    
//            $scope.scatterData = $scope.scatterData.sort(function(a, b){ return a.x > b.x;});
            var averageValues = 0;
            var avg = 0;
            $scope.scatterData.forEach(function(entry){
                avg = avg + entry.y;
                if(averageValues === 3) {
                    var scatterData = {};
                    scatterData.x = entry.x;
                    scatterData.y = avg/4;
                    scatterData.group = 1;
                    averageValues = 0;
                    avg = 0;
                    $scope.scatterData.push(scatterData);
                } else {averageValues++;}
                
            });

            $scope.chart_options = {
                data: [
                    {label: "Mapped", value: 20},
                    {label: "Requested", value: 30},
                    {label: "Rejected", value: 10}
                ]};
        });