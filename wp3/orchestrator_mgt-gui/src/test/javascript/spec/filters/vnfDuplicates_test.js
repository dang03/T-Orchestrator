'use strict';

describe('VNF Duplicates Filter test', function () {
    var filter;

    // load the controller's module
    beforeEach(module('tNovaApp'));

    beforeEach(function ($filter, $rootScope) {
        filter = $filter('vnfDuplicates', {
        });
    });
    describe('reverse', function () {
        it('should return the no duplicated elements a string', inject(function (vnfDuplicatesFilter) {
            expect(vnfDuplicatesFilter(["vi-1", "vi-2", "vi-3"], ["vi-1", "vi-2"])).toEqual(['vi-3']);
        }));
    });
});
