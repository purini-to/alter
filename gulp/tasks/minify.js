var merge = require('event-stream').merge;

var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'main-bower-files']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('minify:js', ['build:coffee'], function () {
    var jsFilter = $.filter('**/*.js');
    var destJsDir = conf.dest + '/javascripts';
    var bowerDest = conf.dest + '/components';

    return merge(
        gulp.src($.mainBowerFiles())
        .pipe(jsFilter)
        .pipe($.concat('vendor.min.js'))
        .pipe($.uglify({preserveComments:'some'}))
        .pipe(gulp.dest(bowerDest)), 
        gulp.src([conf.tmp + '/**/*.js', '!' + conf.tmp + '/bower_components/**/*.js'])
        .pipe($.angularFilesort())
        .pipe($.concat('app.min.js'))
        .pipe($.uglify())
        .pipe(gulp.dest(destJsDir))
    )
});

gulp.task('minify:css', ['build:stylus'], function () {
    var cssFilter = $.filter('**/*.css');
    var destJsDir = conf.dest + '/stylesheets';
    var bowerDest = conf.dest + '/components';

    return merge(
        gulp.src($.mainBowerFiles())
        .pipe(cssFilter)
        .pipe($.replace("url('../", "url('./font-awesome/"))
        .pipe($.concat('vendor.min.css'))
        .pipe($.minifyCss())
        .pipe(gulp.dest(bowerDest)), 
        gulp.src([conf.tmp + '/**/*.css', '!' + conf.tmp + '/bower_components/**/*.css'])
        .pipe($.concat('app.min.css'))
        .pipe($.minifyCss())
        .pipe(gulp.dest(destJsDir))
    )
});

gulp.task('minify:html', function () {
    var destJsDir = conf.dest;

    return gulp.src([conf.src + '/**/*.html', '!' + conf.src + '/views/index.html'])
    .pipe($.minifyHtml())
    .pipe(gulp.dest(destJsDir));
});

gulp.task('minify:assets:json', function () {
    var destJsDir = conf.dest + '/assets';

    return gulp.src([conf.src + '/assets/**/*.json'])
    .pipe($.jsonminify())
    .pipe(gulp.dest(destJsDir));
});

gulp.task('minify:assets', ['minify:assets:json']);

gulp.task('minify', ['minify:js', 'minify:css', 'minify:html', 'minify:assets']);
