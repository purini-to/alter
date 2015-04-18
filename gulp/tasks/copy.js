var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'main-bower-files']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('copy:vendor', ['clean:vendor'], function () {
    var path = confUtil.getPath(conf);

    return gulp.src($.mainBowerFiles(), {base: conf.bowerDir})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe(gulp.dest(path + '/bower_components'));
});

gulp.task('copy:html', ['clean:html'], function () {
    var path = confUtil.getPath(conf);

    return gulp.src([conf.src + '/views/**/*.html', '!' + conf.src + '/views/index.html'], {base: conf.src})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe(gulp.dest(path));
});

gulp.task('copy:assets', ['clean:assets'], function () {
    var path = confUtil.getPath(conf);

    return gulp.src([conf.src + '/assets/**/*'], {base: conf.src})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe(gulp.dest(path));
});

gulp.task('copy:dest', function () {
    var fontFilter = $.filter(['**/*.ttf', '**/*.woff*']);
    var path = conf.dest;

    return gulp.src($.mainBowerFiles(), {base: conf.bowerDir})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe(fontFilter)
        .pipe(gulp.dest(path + '/components'));
});
