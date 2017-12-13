'use strict';

services.factory('summaryDataService', ['$http', 'x2js', 'HistoryService', function ($http, x2js, HistoryService) {
        return {
            get: function (id) {
                var promise = $http.get("rest/api/summary-data/"+id+"?format=json").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get summary data): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            },
            update: function (id, data) {
                var promise = $http.put("rest/api/summary-data/"+id+"?format=json", data).then(function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Reset summary data)";
                    his.type = "INFO";
                    his.$save();
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - POST (Reset summary data): " + response.statusText;
                    his.type = "ERROR";
                    his.$save();
                });
                return promise;
            }
        };
    }]);
