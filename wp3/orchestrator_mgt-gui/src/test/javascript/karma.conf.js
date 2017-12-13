// Karma configuration
// http://karma-runner.github.io/0.10/config/configuration-file.html

module.exports = function (config) {
    config.set({
        // base path, that will be used to resolve files and exclude
        basePath: '../../..',

        // testing framework to use (jasmine/mocha/qunit/...)
        frameworks: ['jasmine'],

        // list of files / patterns to load in the browser
        files: [
            'src/main/webapp/bower_components/jquery/dist/jquery.js',
            'src/main/webapp/bower_components/angular/angular.js',
            'src/main/webapp/bower_components/angular-mocks/angular-mocks.js',
            'src/main/webapp/bower_components/angular-route/angular-route.js',
            'src/main/webapp/bower_components/angular-resource/angular-resource.js',
            'src/main/webapp/bower_components/angular-cookies/angular-cookies.js',
            'src/main/webapp/bower_components/angular-local-storage/dist/angular-local-storage.js',
            'src/main/webapp/bower_components/x2js/xml2json.js',
            'src/main/webapp/bower_components/angular-x2js/dist/x2js.min.js',
            'src/main/webapp/bower_components/ng-table/ng-table.js ',
            'src/main/webapp/bower_components/ngDialog/js/ngDialog.js ',
//            'src/main/webapp/bower_components/**/*.js',
//            'src/main/webapp/bower_components/**/**/*.js',

            'src/main/webapp/js/*.js',
            'src/main/webapp/js/**/*.js',
            'src/test/javascript/**/*.js',
            'src/test/javascript/spec/controllers/HistoryController_test.js'
            
//            'src/test/javascript/**/!(karma.conf).js'
        ],

        // code coverage
        preprocessors: {
//          'src/main/webapp/js/**/*.js': ['coverage']
        },

/*        reporters: ['coverage'],

        coverageReporter: {
          type : 'html',
          dir : 'coverage/'
        },
*/
        reporters : ['progress', 'growl'],
        // list of files / patterns to exclude
        exclude: [
            'src/main/webapp/bower_components/bootstrap/dist/js/bootstrap.js',
            'src/main/webapp/bower_components/bootstrap/dist/js/bootstrap.js'
        ],

        // web server port
        port: 9876,

        // level of logging
        // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
        logLevel: config.LOG_INFO,
        loggers : [{ type: 'console'}],

        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: true,

        // Start these browsers, currently available:
        // - Chrome
        // - ChromeCanary
        // - Firefox
        // - Opera
        // - Safari (only Mac)
        // - PhantomJS
        // - IE (only Windows)
//        browsers: ['PhantomJS'],

        // Continuous Integration mode
        // if true, it capture browsers, run tests and exit
        singleRun: false,
         plugins: [
            'karma-chrome-launcher',
            'karma-jasmine'
        ]
    });
};

