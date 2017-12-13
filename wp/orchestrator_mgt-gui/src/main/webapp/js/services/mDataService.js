'use strict';

services.factory('mDataService', ['$http', 'x2js', 'HistoryService', function ($http, x2js, HistoryService) {
        return {
            list: function () {
                var promise = $http.get("rest/mData").then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get mData list): " + response.statusText;
                    his.type = "ERROR";
//                    his.$save();
                });
                return promise;
            },
            get: function (id) {
                var promise = $http.get("rest/mData/" + id).then(function (response) {
                    return response.data;
                }, function (response) {
                    var his = new HistoryService();
                    his.content = response.status + " - GET (Get mData): " + response.statusText;
                    his.type = "ERROR";
//                    his.$save();
                });
                return promise;
            }
        };
    }]);
