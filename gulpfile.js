var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var livereload = require('gulp-livereload');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var bowerFiles = require('main-bower-files');
var gulpFilter = require('gulp-filter');
var series = require('stream-series');
var inject = require('gulp-inject');
var coffee = require('gulp-coffee');
var stylus = require('gulp-stylus');
var autoprefixer = require('gulp-autoprefixer');
var watch = require('gulp-watch');
var clean = require('gulp-clean');

var path = require('path');

var conf = {
    dest: 'public',
    tmp: '.tmp',
    prod: false,
    bowerDir: 'client/bower_components',
    src: 'client/app'
};

gulp.task('minify:js', function () {
    var jsFilter = gulpFilter('**/*.js');

    return gulp.src(bowerFiles())
        .pipe(jsFilter)
        .pipe(concat('vendor.js'))
        .pipe(uglify({preserveComments:'some'}))
        .pipe(gulp.dest(conf.dest));
});

gulp.task('build', ['compile:coffee', 'compile:stylus', 'copy:html', 'copy:vendor']);

gulp.task('compile:coffee', ['clean:js'], function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src(conf.src + '/**/*.coffee', {base: conf.src})
        .pipe(coffee())
        .pipe(gulp.dest(path));
});

gulp.task('compile:stylus', ['clean:css'], function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src(conf.src + '/**/*.styl', {base: conf.src})
        .pipe(stylus())
        .pipe(autoprefixer())
        .pipe(gulp.dest(path));
});

gulp.task('inject', ['build'], function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src(conf.src + '/views/index.html')
        .pipe(inject(gulp.src(bowerFiles(), {read: false}), {name: 'bower', addRootSlash: false, ignorePath: ['client']}))
        .pipe(inject(gulp.src(path + '/scripts/**/*.js', {read: false}), {name: 'app', addRootSlash: false, ignorePath: ['.tmp']}))
        .pipe(inject(gulp.src(path + '/styles/**/*.css', {read: false}), {name: 'app', addRootSlash: false, ignorePath: ['.tmp']}))
        .pipe(gulp.dest(path));
});

gulp.task('copy:vendor', ['clean:vendor'], function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src(bowerFiles(), {base: conf.bowerDir})
        .pipe(gulp.dest(path + '/bower_components'));
});

gulp.task('copy:html', ['clean:html'], function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src([conf.src + '/views/**/*.html', '!' + conf.src + '/views/index.html'], {base: conf.src})
        .pipe(gulp.dest(path));
});

gulp.task('watch', function () {
    watch([conf.src + '/**/*.coffee', conf.src + '/**/*.styl'], function(file){
        if (file.event === 'change') {
            gulp.start(['compile:coffee', 'compile:stylus']);
        } else {
            gulp.start("inject");
        }
    });

    return watch([conf.src + '/**/*.html'], function(file){
        if (path.basename(file.relative) === 'index.html') {
            gulp.start("inject");
        } else {
            gulp.start("copy:html");
        }
    });
});

gulp.task('clean:js', function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src([path + '/**/*.js', '!' + path + '/bower_components/**/*.js'], {read: false})
        .pipe(clean({force: true}));
});

gulp.task('clean:css', function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src([path + '/**/*.css', '!' + path + '/bower_components/**/*.css'], {read: false})
        .pipe(clean({force: true}));
});

gulp.task('clean:vendor', function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src(path + '/bower_components', {read: false})
        .pipe(clean({force: true}));
});

gulp.task('clean:html', function () {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return gulp.src([path + '/**/*.html', '!' + path + '/bower_components', '!' + path + '/index.html'], {read: false})
        .pipe(clean({force: true}));
});

gulp.task('clean', ['clean:js', 'clean:css', 'clean:vendor']);

gulp.task('serve', ['inject'], function () {
  livereload.listen();

  nodemon({
    script: './bin/www',
    ext: 'js',
    ignore: ['views', 'client', 'build'],
    env: {
      'NODE_ENV': 'development',
      'DEBUG': 'alter'
    }
  }).on('readable', function() {
    // 標準出力に起動完了のログが出力されたらリロードイベント発行
    this.stdout.on('data', function(chunk) {
      if (/^Express\ server\ listening/.test(chunk)) {
        livereload.reload();
      }
      process.stdout.write(chunk);
    });
  });

  gulp.start("watch");

  // node を再起動する必要のないファイル群用の設定
  return gulp.watch([conf.tmp + '/**/*'])
    .on('change', function(event) {
      livereload.changed(event);
    });
});

gulp.task('default', ['serve']);
