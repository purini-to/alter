var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'main-bower-files']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('inject', ['build:coffee', 'build:stylus', 'copy:html', 'copy:assets'], function () {
    var path = confUtil.getPath(conf);

    return gulp.src(conf.src + '/views/index.html')
        .pipe($.inject(gulp.src($.mainBowerFiles(), {read: false}), {name: 'bower', addRootSlash: false, ignorePath: ['client']}))
        .pipe($.inject(gulp.src(path + '/scripts/**/*.js', {read: false}), {name: 'app', addRootSlash: false, ignorePath: ['.tmp']}))
        .pipe($.inject(gulp.src(path + '/styles/**/*.css', {read: false}), {name: 'app', addRootSlash: false, ignorePath: ['.tmp']}))
        .pipe(gulp.dest(path));
});

gulp.task('inject:dest', ['minify'], function () {
    var path = conf.dest;

    return gulp.src(conf.src + '/views/index.html')
        .pipe($.inject(gulp.src(path + '/**/vendor.min.*', {read: false}), {name: 'bower', addRootSlash: false, ignorePath: ['public']}))
        .pipe($.inject(gulp.src(path + '/**/app.min.*', {read: false}), {name: 'app', addRootSlash: false, ignorePath: ['public']}))
        .pipe($.minifyHtml())
        .pipe(gulp.dest(path));
});
