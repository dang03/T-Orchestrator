
services.factory('UserService', function ($resource) {
    /*
     var authService = {};
     
     authService.login = function (credentials) {
     return $http
     .post('/login', credentials)
     .then(function (res) {
     Session.create(res.data.id, res.data.user.id,
     res.data.user.role);
     return res.data.user;
     });
     };
     */

    return $resource('rest/user/:action', {},
            {
                authenticate: {
                    method: 'POST',
                    params: {'action': 'authenticate'},
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                },
            }
    );
});
