/**
 * サーバー側のルーティング設定
 */

'use strict';

module.exports = function(app) {
  app.route('/api/users/login').post(function (req, res, next) {
    var resData = {
      user: {
        id: 2133212,
        name: 'オレオレ',
        token: 'efoij2109fj2o3u0fj320rf0'
      }
    };

    res.send(resData);
  });
};
