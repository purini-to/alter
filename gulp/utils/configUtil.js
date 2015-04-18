var util = {};

util.getPath = function (conf) {
    var path = conf.tmp;
    if (conf.prod) {
        path = conf.dest;
    }

    return path;
};

module.exports = util;
