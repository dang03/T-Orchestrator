'use strict';

angular.module('tNovaApp')
    .controller('infrastructureRepositoryController', function ($rootScope, $scope, $routeParams, $http, localStorageService, $interval, $modal, $timeout) {

        $scope.showPop = true;
        $scope.rootElement = {};
        $scope.tree = [];

        $scope.readInfr = function () {
            var pr = $http.get("resources/infrastructure_repository.json").then(function(response){
                $rootScope.edges = createInfrRepoEdgesModel(response.data);
            });
            var promise = $http.get("resources/infrastructure_repository.json").then(function (response) {
                $rootScope.rootElement = createInfrRepoTreeModel(response.data);
                console.log($rootScope.rootElement);
                $scope.tree = treeToTreeUI($rootScope.rootElement);
                return response.data;
            }).
            finally(function (data) {
                console.log("Finallly");
                $timeout(function () {
                    var data = {};
                    data.nodes = [];
                    data.links = [];
                    var from, to;
                    var i=0;
                    $scope.tree.forEach(function (entry) {
                        data.nodes.push({
                            id: entry.uid,
                            label: entry.label,
                            group: 'pop',
                            value: 20
                        });
                        if(i===0)from = entry.uid; else to=entry.uid
                        i++;
                    });
                    data.links.push({from: from, to: to});
                    $scope.$apply();
                    $rootScope.$broadcast('topologyData', data);
                });
            });
        };

        if (localStorageService.get("infrRepo") === null) {
            var root = $scope.readInfr();
            //$scope.rootElement = root;
            //localStorageService.set("infrRepo", root);
        } else {
            var root = $scope.readInfr();
            //$scope.rootElement = root;
        }

        $scope.ui_handler = function (uid, type) {
            var selected;
            console.log(uid + " " + type);
            if (type === "pop") {
                $scope.tree.forEach(function (entry) {
                    console.log(entry);
                    if (entry.uid === uid) {
                        selected = entry;
                        //$scope.tree.expand_branch();//not working...
                        $scope.my_tree_handler(selected);
                    }
                });
            }
        };
        $scope.my_tree_handler = function (selected) {
            $scope.topologyData = {};
            if (selected.classes[0] === "pop") {
                $scope.showPop = false;
                $scope.showLayers = true;
                $scope.showTopology = false;
                $timeout(function () {
                    $scope.$broadcast('rootElements', $rootScope.rootElement[selected.label]);
                });
            }
        };

        $scope.generateGraph = function(){
            $scope.showPop = false;
            $scope.showLayers = false;
            $scope.showTopology = true;
            var data = {};
            data.nodes = [];
            data.edges = [];
            var pop = $rootScope.rootElement["Intel Ireland's Leixlip Campus, Kildare, Ireland"];
            for(var layers in pop){
                console.log(layers);
                if(layers !== "virtual") break;
                for(var elType in pop[layers]){
                    console.log(pop[layers][elType]);
                    pop[layers][elType].forEach(function (entry){
                       console.log(entry); 
                       data.nodes.push({
                           id: entry.id,
                           label: entry.type,
                           group: entry.layer
                        });
                    });
                }
            }
            
            console.log($rootScope.edges);
            data.links = $rootScope.edges;
            
            //$scope.$apply();
            //$rootScope.$broadcast('completeTopologyData', data);
            $timeout(function () {
                    $rootScope.$broadcast('completeTopologyData', data);
            });
        };

        $scope.selectedLayer = [
            { name: "virtual", id: 0, isChecked: false }, 
            { name: "physical", id: 1, isChecked: false }, 
            { name: "service", id: 2, isChecked: false },
            { name: "vnf", id: 3, isChecked: false }
        ];
    
        $scope.filter = function(){
            var data = {};
            data.nodes = [];
            data.edges = [];
            var pop = $rootScope.rootElement["Intel Ireland's Leixlip Campus, Kildare, Ireland"];
            for (var i=0; i< $scope.selectedLayer.length; i++){
                if($scope.selectedLayer[i].isChecked !== true) continue;
                var layer = $scope.selectedLayer[i].name;
                for(var elType in pop[layer]){
                    pop[layer][elType].forEach(function (entry){
                        data.nodes.push({
                            id: entry.id,
                            label: entry.type,
                            group: entry.layer
                        });
                    });
                }
            }
            
            data.links = $rootScope.edges;
            
            $timeout(function () {
                $rootScope.$broadcast('completeTopologyData', data);
            });
        };
    })
    .controller("popLayer", function ($rootScope, $scope, ngTableParams, $filter, $modal) {
        $scope.tableDisplay = false;
	
	$scope.showTable = function (layer, name) {
//          if(!$scope.tableDisplay) $scope.showTable2();
//            $scope.tableDisplay = true;
            $scope.data = [];
            console.log("Show table: " + layer + " - " + name);
            $scope.data = $rootScope.rootElement["Intel Ireland's Leixlip Campus, Kildare, Ireland"][layer][name];
        console.log("Table reload");
 if(!$scope.tableDisplay) {
        console.log("inside");
        $scope.tableDisplay = true;
        $scope.showTable2();
        }else{
            $scope.tableParams.reload();
}
        }

        $scope.showTable2 = function(){
        $scope.tableDisplay = true;
        $scope.tableParams = new ngTableParams({
                count: $scope.data.length,
                sorting: {
                    id: 'desc' // initial sorting
                },
            }, {
                total: $scope.data.length,
                getData: function ($defer, params) {
                console.log("GEt Data");
console.log($scope.data);
                    var orderedData = params.sorting() ? $filter('orderBy')($scope.data, params.orderBy()) : $scope.data;
                    $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()));
                },
                $scope: {
                    $data: {}
                }
            });
}

/*
        $scope.showTable = function (layer, name) {
            $scope.tableDisplay = true;
            $scope.data = {};
            console.log("Show table: " + layer + " - " + name);
            $scope.data = $rootScope.rootElement["Intel Ireland's Leixlip Campus, Kildare, Ireland"][layer][name];
            //$scope.tableParams.reload();
            $scope.tableParams = new ngTableParams({
                count: $scope.data.length,
                sorting: {
                    id: 'desc' // initial sorting
                },
            }, {
                total: $scope.data.length,
                getData: function ($defer, params) {
                    var orderedData = params.sorting() ? $filter('orderBy')($scope.data, params.orderBy()) : $scope.data;
                    $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()));
                },
                $scope: {
                    $data: {}
                }
            });

        };
*/
        $scope.showDescriptor = function (data) {
            $scope.jsonObj = JSON.parse(data);
            $modal({
                title: "Attributes",
                content: "",
                template: "partials/t-nova/modals/descriptors.html",
                show: true,
                scope: $scope,
            });
        };
    });

function treeToTreeUI(rootResource) {
    var tree = [];

    Object.keys(rootResource).forEach(function (p) {
        var pop = {
            label: p,
            children: [],
            classes: ['pop']
        };
        Object.keys(rootResource[p]).forEach(function (l) {
            var layer = {
                label: l,
                children: [],
                classes: ['layer']
            };
            Object.keys(rootResource[p][l]).forEach(function (t) {
                var type = {
                    label: t,
                    children: [],
                    classes: ['type']
                };
                layer.children.push(type);
            });
            pop.children.push(layer);
        });
        tree.push(pop);
    });
    return tree;
}

function createInfrRepoTreeModel(jsonObject) {
    var root = [];
    var rootResource = {};
    var nodes = jsonObject.nodes;
    Object.keys(nodes).forEach(function (key) {
        var node = nodes[key];
        node.id = parseInt(key);
        if (rootResource[node.pop] === undefined) {
            console.log(node.pop);
            rootResource[node.pop] = {};
        }
        if (rootResource[node.pop][node.layer] === undefined) {
            rootResource[node.pop][node.layer] = {};
        }
        if (node.type !== undefined) {
            if (rootResource[node.pop][node.layer][node.type] === undefined) {
                rootResource[node.pop][node.layer][node.type] = [];
            }
            rootResource[node.pop][node.layer][node.type].push(node);
        } else console.log(node);
    });
    root.push(rootResource);
    return rootResource;
}

function createInfrRepoEdgesModel(jsonObject) {

    var root = [];
    var rootResource = {};
    var edges = jsonObject.edges;
    Object.keys(edges).forEach(function (key) {
        var edge = {};
        edge.from = parseInt(edges[key][0].substring(1, edges[key][0].length-1));
        edge.to = parseInt(edges[key][1].substring(1, edges[key][1].length-1));
        edge.label = edges[key][2];
        root.push(edge);
    });
    root.push(rootResource);
    return root;
}
