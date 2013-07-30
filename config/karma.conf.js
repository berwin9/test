var os = require('os');

var platform = os.platform() === 'darwin' ? 'mac' : 'win';

basePath = '../';

files = [
    JASMINE,
    JASMINE_ADAPTER,
    'src/server/public/js/libs.js',
    'specs/libs/angular/angular-mocks.js',
    'src/server/public/js/app.js',
    'specs/client/js/client/*.js'
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
