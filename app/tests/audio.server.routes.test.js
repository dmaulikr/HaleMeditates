'use strict';

var should = require('should'),
	request = require('supertest'),
	app = require('../../server'),
	mongoose = require('mongoose'),
	User = mongoose.model('User'),
	Audio = mongoose.model('Audio'),
	agent = request.agent(app);

/**
 * Globals
 */
var credentials, user, audio;

/**
 * Audio routes tests
 */
describe('Audio CRUD tests', function() {
	beforeEach(function(done) {
		// Create user credentials
		credentials = {
			username: 'username',
			password: 'password'
		};

		// Create a new user
		user = new User({
			firstName: 'Full',
			lastName: 'Name',
			displayName: 'Full Name',
			email: 'test@test.com',
			username: credentials.username,
			password: credentials.password,
			provider: 'local'
		});

		// Save a user to the test db and create new Audio
		user.save(function() {
			audio = {
				name: 'Audio Name'
			};

			done();
		});
	});

	it('should be able to save Audio instance if logged in', function(done) {
		agent.post('/auth/signin')
			.send(credentials)
			.expect(200)
			.end(function(signinErr, signinRes) {
				// Handle signin error
				if (signinErr) done(signinErr);

				// Get the userId
				var userId = user.id;

				// Save a new Audio
				agent.post('/audios')
					.send(audio)
					.expect(200)
					.end(function(audioSaveErr, audioSaveRes) {
						// Handle Audio save error
						if (audioSaveErr) done(audioSaveErr);

						// Get a list of Audios
						agent.get('/audios')
							.end(function(audiosGetErr, audiosGetRes) {
								// Handle Audio save error
								if (audiosGetErr) done(audiosGetErr);

								// Get Audios list
								var audios = audiosGetRes.body;

								// Set assertions
								(audios[0].user._id).should.equal(userId);
								(audios[0].name).should.match('Audio Name');

								// Call the assertion callback
								done();
							});
					});
			});
	});

	it('should not be able to save Audio instance if not logged in', function(done) {
		agent.post('/audios')
			.send(audio)
			.expect(401)
			.end(function(audioSaveErr, audioSaveRes) {
				// Call the assertion callback
				done(audioSaveErr);
			});
	});

	it('should not be able to save Audio instance if no name is provided', function(done) {
		// Invalidate name field
		audio.name = '';

		agent.post('/auth/signin')
			.send(credentials)
			.expect(200)
			.end(function(signinErr, signinRes) {
				// Handle signin error
				if (signinErr) done(signinErr);

				// Get the userId
				var userId = user.id;

				// Save a new Audio
				agent.post('/audios')
					.send(audio)
					.expect(400)
					.end(function(audioSaveErr, audioSaveRes) {
						// Set message assertion
						(audioSaveRes.body.message).should.match('Please fill Audio name');
						
						// Handle Audio save error
						done(audioSaveErr);
					});
			});
	});

	it('should be able to update Audio instance if signed in', function(done) {
		agent.post('/auth/signin')
			.send(credentials)
			.expect(200)
			.end(function(signinErr, signinRes) {
				// Handle signin error
				if (signinErr) done(signinErr);

				// Get the userId
				var userId = user.id;

				// Save a new Audio
				agent.post('/audios')
					.send(audio)
					.expect(200)
					.end(function(audioSaveErr, audioSaveRes) {
						// Handle Audio save error
						if (audioSaveErr) done(audioSaveErr);

						// Update Audio name
						audio.name = 'WHY YOU GOTTA BE SO MEAN?';

						// Update existing Audio
						agent.put('/audios/' + audioSaveRes.body._id)
							.send(audio)
							.expect(200)
							.end(function(audioUpdateErr, audioUpdateRes) {
								// Handle Audio update error
								if (audioUpdateErr) done(audioUpdateErr);

								// Set assertions
								(audioUpdateRes.body._id).should.equal(audioSaveRes.body._id);
								(audioUpdateRes.body.name).should.match('WHY YOU GOTTA BE SO MEAN?');

								// Call the assertion callback
								done();
							});
					});
			});
	});

	it('should be able to get a list of Audios if not signed in', function(done) {
		// Create new Audio model instance
		var audioObj = new Audio(audio);

		// Save the Audio
		audioObj.save(function() {
			// Request Audios
			request(app).get('/audios')
				.end(function(req, res) {
					// Set assertion
					res.body.should.be.an.Array.with.lengthOf(1);

					// Call the assertion callback
					done();
				});

		});
	});


	it('should be able to get a single Audio if not signed in', function(done) {
		// Create new Audio model instance
		var audioObj = new Audio(audio);

		// Save the Audio
		audioObj.save(function() {
			request(app).get('/audios/' + audioObj._id)
				.end(function(req, res) {
					// Set assertion
					res.body.should.be.an.Object.with.property('name', audio.name);

					// Call the assertion callback
					done();
				});
		});
	});

	it('should be able to delete Audio instance if signed in', function(done) {
		agent.post('/auth/signin')
			.send(credentials)
			.expect(200)
			.end(function(signinErr, signinRes) {
				// Handle signin error
				if (signinErr) done(signinErr);

				// Get the userId
				var userId = user.id;

				// Save a new Audio
				agent.post('/audios')
					.send(audio)
					.expect(200)
					.end(function(audioSaveErr, audioSaveRes) {
						// Handle Audio save error
						if (audioSaveErr) done(audioSaveErr);

						// Delete existing Audio
						agent.delete('/audios/' + audioSaveRes.body._id)
							.send(audio)
							.expect(200)
							.end(function(audioDeleteErr, audioDeleteRes) {
								// Handle Audio error error
								if (audioDeleteErr) done(audioDeleteErr);

								// Set assertions
								(audioDeleteRes.body._id).should.equal(audioSaveRes.body._id);

								// Call the assertion callback
								done();
							});
					});
			});
	});

	it('should not be able to delete Audio instance if not signed in', function(done) {
		// Set Audio user 
		audio.user = user;

		// Create new Audio model instance
		var audioObj = new Audio(audio);

		// Save the Audio
		audioObj.save(function() {
			// Try deleting Audio
			request(app).delete('/audios/' + audioObj._id)
			.expect(401)
			.end(function(audioDeleteErr, audioDeleteRes) {
				// Set message assertion
				(audioDeleteRes.body.message).should.match('User is not logged in');

				// Handle Audio error error
				done(audioDeleteErr);
			});

		});
	});

	afterEach(function(done) {
		User.remove().exec();
		Audio.remove().exec();
		done();
	});
});