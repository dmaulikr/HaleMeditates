'use strict';

//Setting up route
angular.module('audios').config(['$stateProvider',
	function($stateProvider) {
		// Audios state routing
		$stateProvider.
		state('listAudios', {
			url: '/audios',
			templateUrl: 'modules/audios/views/list-audios.client.view.html'
		}).
		state('createAudio', {
			url: '/audios/create',
			templateUrl: 'modules/audios/views/create-audio.client.view.html'
		}).
		state('viewAudio', {
			url: '/audios/:audioId',
			templateUrl: 'modules/audios/views/view-audio.client.view.html'
		}).
		state('editAudio', {
			url: '/audios/:audioId/edit',
			templateUrl: 'modules/audios/views/edit-audio.client.view.html'
		});
	}
]);