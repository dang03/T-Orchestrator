'use strict';

services.factory('nsService', ['$http', 'x2js', 'HistoryService', function ($http, x2js, HistoryService) {
        return {
            list: function () {
                var promise = $http.get("rest/api/network-services").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Request NS list): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            get: function (id) {
                var promise = $http.get("rest/api/network-services/" + id + "").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get NS: "+id+"): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            delete: function (id) {
                var promise = $http.delete("rest/api/network-services/" + id).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (NS" + id + " removed)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Delete NS "+id+"): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            post: function (data) {//data in json format {"name":"SP4"}
                var promise = $http.post("rest/api/network-services/", data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (NS created): " + response.statusText;
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Create NS): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            update: function (id, data) {//data in json format {"name":"SP4"}
                var promise = $http.post("rest/api/network-services/"+id, data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (NS updated): " + response.statusText;
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Update NS): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            add: function (id, vnfId) {
                var promise = $http.get("rest/network-services/" + id + "/vnf/" + vnfId).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Add nf to NS): " + response.data;
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Add nf to NS): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            removeVNF: function (id, vnfId) {
                var promise = $http.delete("rest/network-services/" + id + "/vi/" + vnfId).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Remove VNF): " + response.data;
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Remove VNF): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            }
        };
    }]);
