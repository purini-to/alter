var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'del']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('clean:js', function () {
    var path = confUtil.getPath(conf);

    return gulp.src([path + '/**/*.js', '!' + path + '/bower_components/**/*.js'], {read: false})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.clean({force: true}));
});

gulp.task('clean:css', function () {
    var path = confUtil.getPath(conf);

    return gulp.src([path + '/**/*.css', '!' + path + '/bower_components/**/*.css'], {read: false})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.clean({force: true}));
});

gulp.task('clean:vendor', function () {
    var path = confUtil.getPath(conf);

    return gulp.src(path + '/bower_components', {read: false})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.clean({force: true}));
});

gulp.task('clean:html', function () {
    var path = confUtil.getPath(conf);

    return gulp.src([path + '/**/*.html', '!' + path + '/bower_components', '!' + path + '/index.html'], {read: false})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.clean({force: true}));
});

gulp.task('clean:assets', function () {
    var path = confUtil.getPath(conf);

    return gulp.src([path + '/assets/**/*'], {read: false})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.clean({force: true}));
});

gulp.task('clean:dest', function (cb) {
    $.del(conf.dest + '/**/*', cb)
});

gulp.task('clean:server', function (cb) {
    $.del(conf.build + '/**/*', cb);
});

gulp.task('clean', ['clean:js', 'clean:css', 'clean:vendor', 'clean:dest', 'clean:server']);
