'use strict';

module.exports = function(app) {
	var users = require('../../app/controllers/users.server.controller');
	var audios = require('../../app/controllers/audios.server.controller');

	// Audios Routes
	app.route('/audios')
		.get(audios.list)
		.post(users.requiresLogin, audios.create);

	app.route('/audios/:audioId')
		.get(audios.read)
		.put(users.requiresLogin, audios.hasAuthorization, audios.update)
		.delete(users.requiresLogin, audios.hasAuthorization, audios.delete);

	// Finish by binding the Audio middleware
	app.param('audioId', audios.audioByID);
};
