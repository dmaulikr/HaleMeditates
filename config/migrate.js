/**
 * Created by Pillsbury on 6/14/15.
 */

var env = require('./env/all'),
    lodash = require('lodash'),
    exportObject = {};

lodash.extend(env, require('./env/' + process.env.NODE_ENV) || {});

exportObject[process.env.NODE_ENV] = {
    schema: { 'migration': {} },
    modelName: 'Migration',
    db: env.db
};

module.exports = exportObject;
