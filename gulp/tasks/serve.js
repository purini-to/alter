var gulp = require('gulp');
var $ = require('gulp-load-plugins')({
    pattern: ['gulp-*', 'main-bower-files']
});

var conf = require('../config.js');
var confUtil = require('../utils/configUtil.js');

gulp.task('serve', ['copy:vendor', 'inject'], function () {
  $.livereload.listen();

  $.nodemon({
    script: './bin/www',
    ext: 'js',
    ignore: ['gulp', 'client', 'public'],
    env: {
      'NODE_ENV': 'development',
      'DEBUG': 'alter'
    }
  }).on('readable', function() {
    // 標準出力に起動完了のログが出力されたらリロードイベント発行
    this.stdout.on('data', function(chunk) {
      if (/^Express\ server\ listening/.test(chunk)) {
        $.livereload.reload();
      }
      process.stdout.write(chunk);
    });
  });

  gulp.start("watch:app");

  // node を再起動する必要のないファイル群用の設定
  return gulp.watch([conf.tmp + '/**/*'])
    .on('change', function(event) {
      $.livereload.changed(event);
    });
});

gulp.task('serve:dest', ['copy:dest', 'inject:dest'], function () {
  return $.nodemon({
    script: './bin/www',
    ext: 'js',
    ignore: ['gulp', 'client', 'public'],
    env: {
      'NODE_ENV': 'production',
      'DEBUG': 'alter'
    }
  })
});
