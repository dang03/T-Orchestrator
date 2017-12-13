'use strict';

describe('History controller test', function () {
    var controller, scope;
    var http;

    // load the controller's module
    beforeEach(module('tNovaApp'));

    beforeEach(inject(function ($controller, $rootScope) {
        scope = $rootScope.$new();
        controller = $controller('HistoryListController', {
            $scope: scope
        });
    }));


    it('has correct initial values', function () {
        expect(scope.tableParams.data.length).toBe(0);
//            expect(scope.tableParams.data.length).toEqual(1);
    });

});

