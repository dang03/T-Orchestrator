'use strict';

services.factory('vnfService', ['$http', 'x2js', 'HistoryService', function ($http, x2js, HistoryService) {
        return {
            list: function () {
                var promise = $http.get("rest/api/vnfs").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get list of VNFs): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            get: function (id) {
                var promise = $http.get("rest/api/vnfs/" + id ).then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get VNF): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            post: function (data) {//data in json format {"name":"SP4"}
                var promise = $http.post("rest/api/vnfs/", data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (VNF Created)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (VNF Created): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            delete: function (id, viId) {
                var promise = $http.delete("rest/api/vnfs/" + id).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (VNF " + id + " removed)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Delete VNF): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            }
        };
    }]);
