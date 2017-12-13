'use strict';

services.factory('msService', ['$http', 'x2js', 'HistoryService', function ($http, x2js, HistoryService) {
        return {
            list: function () {
                var promise = $http.get("rest/api/configs/services").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Request Microservice list): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            get: function (id) {
                var promise = $http.get("rest/api/configs/services?name=" + id + "").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get Microservice: "+id+"): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            delete: function (id) {
                var promise = $http.delete("rest/api/configs/services?name=" + id).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Microservice " + id + " removed)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Delete Microservice "+id+"): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            post: function (data) {//data in json format {"name":"SP4"}
                var promise = $http.post("rest/api/configs/registerService", data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Microservice created): " + response.statusText;
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Create Microservice): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            update: function (id, data) {//data in json format {"name":"SP4"}
                var promise = $http.put("rest/api/configs/services?name="+id, data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Microservice updated): " + response.statusText;
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Update Microservice): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
        };
    }]);
