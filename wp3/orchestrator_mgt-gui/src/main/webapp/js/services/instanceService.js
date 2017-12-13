'use strict';

services.factory('instanceService', ['$http', 'x2js', 'HistoryService', function ($http, x2js, HistoryService) {
        return {
            list: function (type) {
                var promise = $http.get("rest/api/"+type+"-instances").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get instance list): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            get: function (type, id) {
                var promise = $http.get("rest/api/"+type+"-instances/" + id ).then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get instance): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            create: function (type, data) {//data in json format {"name":"SP4"}
                var promise = $http.post("rest/api/"+type+"-instances", data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST ("+type+" instance created)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Create instance): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            update: function (type, id, data) {//data in json format {"name":"SP4"}
                var promise = $http.put("rest/api/"+type+"instances/"+id, data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Update "+type+" instance)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Update instance): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            remove: function (type, id) {
                var promise = $http.delete("rest/api/"+type+"-instances/"+id ).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Removed instance)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - REMOVE (Removed instance): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            }
        };
    }]);
