'use strict';

angular.module('tNovaApp', ['ngResource', 'ngRoute', 'ngCookies', 'tNovaApp.services', 'LocalStorageModule', 'cb.x2js', 'smart-table', 'mgcrea.ngStrap', 'ngPrettyJson', 'angularBootstrapNavTree', 'easypiechart'])
    .config(function (localStorageServiceProvider) {
        localStorageServiceProvider
            .setPrefix('tNovaApp')
            .setStorageType('sessionStorage')
            .setNotify(true, true);
    }).config(
        ['$routeProvider', '$locationProvider', '$httpProvider', function ($routeProvider, $locationProvider, $httpProvider) {

            $routeProvider
                .when('/login', {
                    templateUrl: 'partials/login.html',
                    controller: 'LoginController'
                })
                .when('/users', {
                    templateUrl: 'partials/users.html',
                    controller: 'UsersController'
                })
                .when('/profile', {
                    templateUrl: 'partials/users.html',
                    controller: 'UserProfileController'
                })
                .when('/history', {
                    templateUrl: 'partials/history/index.html',
                    controller: 'HistoryListController'
                })
                .when('/ns', {
                    templateUrl: 'partials/t-nova/ns.html',
                    controller: 'nsController'
                })
                .when('/vnf', {
                    templateUrl: 'partials/t-nova/vnf.html',
                    controller: 'vnfController'
                })
                .when('/nsInstances', {
                    templateUrl: 'partials/t-nova/nsInstances.html',
                    controller: 'nsInstancesController'
                })
                .when('/nsInstances/:id', {
                    templateUrl: 'partials/t-nova/nsInstances.html',
                    controller: 'nsInstancesController'
                })
                .when('/vnfInstances', {
                    templateUrl: 'partials/t-nova/vnfInstances.html',
                    controller: 'vnfInstancesController'
                })
                .when('/nsMonitoring', {
                    templateUrl: 'partials/t-nova/nsMonitoring.html',
                    controller: 'nsInstancesController'
                })
                .when('/nsMonitoring/:id', {
                    templateUrl: 'partials/t-nova/nsMonitoring.html',
                    controller: 'nsMonitoringController'
                })
                .when('/vnfMonitoring', {
                    templateUrl: 'partials/t-nova/vnfMonitoring.html',
                    controller: 'vnfInstancesController'
                })
                .when('/vnfMonitoring/:id', {
                    templateUrl: 'partials/t-nova/vnfMonitoring.html',
                    controller: 'vnfMonitoringController'
                })
                .when('/mappingAlgorithm', {
                    templateUrl: 'partials/t-nova/mappingAlgorithm.html',
                    controller: 'mappingAlgorithmController'
                })
                .when('/infrastructureRepository', {
                    templateUrl: 'partials/t-nova/infrastructureRepository.html',
                    controller: 'infrastructureRepositoryController'
                })
                .when('/configuration', {
                    templateUrl: 'partials/t-nova/configuration.html',
                    controller: 'configurationController'
                })
                .when('/modules', {
                    templateUrl: 'partials/t-nova/modules.html',
                    controller: 'modulesController'
                })
                .otherwise({
                    templateUrl: 'partials/index.html',
                    controller: 'HomeController'
                });

            $locationProvider.hashPrefix('!');

            /* Register error provider that shows message on failed requests or redirects to login page on
             * unauthenticated requests */
            $httpProvider.interceptors.push(function ($q, $rootScope, $location) {
                return {
                    'responseError': function (rejection) {
                        var status = rejection.status;
                        var config = rejection.config;
                        var method = config.method;
                        var url = config.url;

                        if (status == 401) {
                            $location.path("/login");
                        } else {
                            $rootScope.error = method + " on " + url + " failed with status " + status;
                        }

                        return $q.reject(rejection);
                    }
                };
            });

            /* Registers auth token interceptor, auth token is either passed by header or by query parameter
             * as soon as there is an authenticated user */
            $httpProvider.interceptors.push(function ($q, $rootScope, $location) {
                return {
                    'request': function (config) {
                        var isRestCall = config.url.indexOf('rest') == 0;
                        if (isRestCall && angular.isDefined($rootScope.authToken)) {
                            var authToken = $rootScope.authToken;
                            if (tNovaAppConfig.useAuthTokenHeader) {
                                config.headers['X-Auth-Token'] = authToken;
                            } else {
                                config.url = config.url + "?token=" + authToken;
                            }
                        }
                        return config || $q.when(config);
                    }
                };
            });

            }]

    ).run(function ($rootScope, $location, $cookieStore, UserService) {

        /* Reset error when a new view is loaded */
        $rootScope
            .$on('$viewContentLoaded', function () {
                delete $rootScope.error;
            });

        $rootScope.hasRole = function (role) {

            if ($rootScope.user === undefined) {
                return false;
            }

            if ($rootScope.user.roles[role] === undefined) {
                return false;
            }

            return $rootScope.user.roles[role];
        };

        $rootScope.logout = function () {
            delete $rootScope.user;
            delete $rootScope.authToken;
            $cookieStore.remove('authToken');
            $location.path("/login");
        };

        /* Try getting valid user from cookie or go to login page */
        var originalPath = $location.path();
        $location.path("/login");
        var authToken = $cookieStore.get('authToken');
        if (authToken !== undefined) {
            $rootScope.authToken = authToken;
            UserService.get(function (user) {
                $rootScope.user = user;
                $location.path(originalPath);
            });
        }

        $rootScope.initialized = true;
    });

var services = angular.module('tNovaApp.services', ['ngResource']);
var genericUrl = "rest/tnova/";
var graph;
var defaultTimer = 2000; //2000
