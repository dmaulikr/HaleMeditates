'use strict';

/**
 * Module dependencies.
 */
var _ = require('lodash'),
	errorHandler = require('../errors.server.controller.js'),
	mongoose = require('mongoose'),
	passport = require('passport'),
	User = mongoose.model('User');

/**
 * Update user details
 */
exports.update = function(req, res) {
	// Init Variables
	var user = req.user;
	var message = null;

	// For security measurement we remove the roles from the req.body object
	delete req.body.roles;

	if (user) {
		// Merge existing user
		var userCopy = req.body;
		userCopy.updated = Date.now();

		User.update({_id: user.id}, {$set: userCopy}, function(err) {
			if (err) {
				return res.status(400).send({
					message: errorHandler.getErrorMessage(err)
				});
			} else {
				user = _.extend(user, userCopy);
				user.updated = Date.now();
				user.displayName = user.firstName + ' ' + user.lastName;
				req.login(user, function(err) {
					if (err) {
						res.status(400).send(err);
					} else {
						res.json(user);
					}
				});
			}
		});
	} else {
		res.status(400).send({
			message: 'User is not signed in'
		});
	}
};

exports.addJournalEntry = function (req, res) {
	var user = req.user;
	var journalEntry = req.body;
	user.journals.push(journalEntry);
	User.update({_id: user.id}, {$set: {
		journals: user.journals
	}}, function(err) {
		if (err) {
			return res.status(400).send({
				message: errorHandler.getErrorMessage(err)
			});
		} else {
			res.jsonp(user);
		}
	});
};

exports.editJournalEntry = function (req, res) {
	var user = req.user;
	var journalEntry = req.body;
	var indexToEdit = _.findIndex(user.journals, function(journal) {
		return journal._id == journalEntry._id;
	});

	if (indexToEdit === -1) {
		return res.status(400).send({
			message: "Could not find corresponding journal entry with id " + journalEntry._id
		});
	}

	user.journals[indexToEdit] = _.extend(user.journals[indexToEdit], journalEntry);
	User.update({_id: user.id}, {$set: {
		journals: user.journals
	}}, function (err) {
		if (err) {
			return res.status(400).send({
				message: errorHandler.getErrorMessage(err)
			});
		} else {
			req.login(user, function(err) {
				if (err) {
					res.status(400).send(err);
				} else {
					res.json(user);
				}
			});
		}
	});
};

/**
 * Send User
 */
exports.me = function(req, res) {
	res.json(req.user || null);
};