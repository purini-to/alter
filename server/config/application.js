'use strict';

var express = require('express');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var ECT = require('ect');

// 環境に応じた設定を読み込み
var config = require('./env_settings');

var ectRenderer = ECT({ watch: true, root: config.root + '/server/views', ext : '.ect' })

module.exports = function(app) {
  var env = config.env;

  app.set('env', env);
  app.set('views', config.root + '/server/views');
  app.engine('ect', ectRenderer.render);
  app.set('view engine', 'ect');
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(bodyParser.json());
  app.use(cookieParser());
  if ('production' === env) {
    //app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
    app.use(express.static(path.join(config.root, 'public')));
    app.set('appPath', config.root + '/public');
    app.use(logger('dev'));
  }

  if ('development' === env || 'test' === env) {
    app.use(require('connect-livereload')());
    app.use(express.static(path.join(config.root, '/.tmp')));
    app.set('appPath', '/.tmp');
    app.use(logger('dev'));
  }
};
