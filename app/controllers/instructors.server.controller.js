'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    errorHandler = require('./errors.server.controller'),
    Instructor = mongoose.model('Instructor'),
    _ = require('lodash');

/**
 * List of Audios
 */
exports.list = function(req, res) {
    Instructor.find().sort('-created').populate('user', 'displayName').exec(function(err, instructors) {
        if (err) {
            return res.status(400).send({
                message: errorHandler.getErrorMessage(err)
            });
        } else {
            res.jsonp(instructors);
        }
    });
};
