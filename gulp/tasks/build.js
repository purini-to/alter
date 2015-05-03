var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('build:coffee', ['copy:js'], function () {
    var path = confUtil.getPath(conf);

    return gulp.src(conf.src + '/**/*.coffee', {base: conf.src})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.coffee())
        .pipe($.ngAnnotate())
        .pipe(gulp.dest(path));
});

gulp.task('build:coffee:server', ['clean:server'], function () {
    var path = conf.build;

    return gulp.src(conf.serverSrc + '/**/*.coffee', {base: conf.serverSrc})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.coffee())
        .pipe(gulp.dest(path));
});

gulp.task('build:stylus', ['clean:css'], function () {
    var path = confUtil.getPath(conf);

    return gulp.src(conf.src + '/**/*.styl', {base: conf.src})
        .pipe($.plumber({errorHandler: $.notify.onError('<%= error.message %>')}))
        .pipe($.stylus())
        .pipe($.autoprefixer())
        .pipe(gulp.dest(path));
});

gulp.task('build', ['build:coffee', 'build:stylus', 'build:coffee:server']);
