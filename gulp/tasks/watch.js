var path = require('path');
var merge = require('event-stream').merge;

var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'main-bower-files']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('watch:app', function () {
    return merge(
        $.watch([conf.src + '/**/*.coffee', conf.src + '/**/*.styl'], function(file){
            if (file.event === 'change') {
                gulp.start(['build:coffee', 'build:stylus']);
            } else {
                gulp.start("inject");
            }
        }), 
        $.watch([conf.src + '/**/*.html'], function(file){
            if (path.basename(file.relative) === 'index.html') {
                gulp.start("inject");
            } else {
                gulp.start("copy:html");
            }
        }), 
        $.watch([conf.src + '/assets/**/*'], function(file){
            gulp.start("copy:assets");
        }),
        $.watch([conf.serverSrc + '/**/*.coffee'], function(file){
            gulp.start("build:coffee:server");
        })
    );
});
