'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	errorHandler = require('./errors.server.controller'),
	Audio = mongoose.model('Audio'),
	Instructor = mongoose.model('Instructor'),
	_ = require('lodash');

/**
 * Create a Audio
 */
exports.create = function(req, res) {
	if (_.isObject(req.body.instructor)) {
		var instructor = new Instructor(req.body.instructor);
		instructor.save(function(err) {
			if (err) {
				return res.status(400).send({
					message: errorHandler.getErrorMessage(err)
				});
			} else {
				return saveNewAudio(instructor, req, res);
			}
		});
	} else {
		Instructor.findById(req.body.instructor).exec(function(err, instructorResult) {
			if (!instructorResult || err) {
				return res.status(400).send({
					message: errorHandler.getErrorMessage(err)
				});
			} else {
				return saveNewAudio(instructorResult, req, res);
			}
		});
	}
};

function saveNewAudio(instructor, req, res) {
	var audio = new Audio({
		duration: req.body.duration,
		name: req.body.name,
		file: req.body.file,
		instructor: instructor,
		user: req.user
	});
	audio.save(function(err) {
		if (err) {
			return res.status(400).send({
				message: errorHandler.getErrorMessage(err)
			});
		} else {
			res.jsonp(audio);
		}
	});

}

/**
 * Show the current Audio
 */
exports.read = function(req, res) {
	res.jsonp(req.audio);
};

/**
 * Update a Audio
 */
exports.update = function(req, res) {
	var audio = req.audio ;

	audio = _.extend(audio , req.body);

	audio.save(function(err) {
		if (err) {
			return res.status(400).send({
				message: errorHandler.getErrorMessage(err)
			});
		} else {
			res.jsonp(audio);
		}
	});
};

/**
 * Delete an Audio
 */
exports.delete = function(req, res) {
	var audio = req.audio ;

	audio.remove(function(err) {
		if (err) {
			return res.status(400).send({
				message: errorHandler.getErrorMessage(err)
			});
		} else {
			res.jsonp(audio);
		}
	});
};

/**
 * List of Audios
 */
exports.list = function(req, res) { 
	Audio.find().sort('-created').populate('user', 'displayName').populate('instructor').exec(function(err, audios) {
		if (err) {
			return res.status(400).send({
				message: errorHandler.getErrorMessage(err)
			});
		} else {
			res.jsonp(audios);
		}
	});
};

/**
 * Audio middleware
 */
exports.audioByID = function(req, res, next, id) { 
	Audio.findById(id).populate('user', 'displayName').populate('instructor').exec(function(err, audio) {
		if (err) return next(err);
		if (! audio) return next(new Error('Failed to load Audio ' + id));
		req.audio = audio ;
		next();
	});
};

/**
 * Audio authorization middleware
 */
exports.hasAuthorization = function(req, res, next) {
	if (req.audio.user.id !== req.user.id) {
		return res.status(403).send('User is not authorized');
	}
	next();
};
