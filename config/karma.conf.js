var os = require('os');

var platform = os.platform() === 'darwin' ? 'mac' : 'win';

basePath = '../';

files = [
    JASMINE,
    JASMINE_ADAPTER,
    'lib/jquery/jquery-1.9.1.js',
    'lib/underscore/underscore.js',
    'lib/angular/angular.1.1.5.js',
    'lib/angular/angular-*.js',
    'lib/angularstrap/angular-strap.js',
    'test/lib/angular/angular-mocks.js',
    'common/util.js',
    'editor/**/*.js',
    'test/unit/**/*.js',
];

autoWatch = true;

if (platform === 'mac') {
    browsers = ['PhantomJS', 'Firefox', 'Chrome']
} else {
    browsers = ['PhantomJS', 'Firefox', 'Chrome', 'IE']
}

junitReporter = {
    outputFile: 'test_out/unit.xml',
    suite: 'unit'
};