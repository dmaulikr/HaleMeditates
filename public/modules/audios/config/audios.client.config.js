'use strict';

// Configuring the Articles module
angular.module('audios').run(['Menus',
	function(Menus) {
		// Set top bar menu items
		Menus.addMenuItem('topbar', 'Audios', 'audios', 'dropdown', '/audios(/create)?');
		Menus.addSubMenuItem('topbar', 'audios', 'List Audios', 'audios');
		Menus.addSubMenuItem('topbar', 'audios', 'New Audio', 'audios/create');
	}
]);

angular.module('audios').config(function($sceDelegateProvider) {
	$sceDelegateProvider.resourceUrlWhitelist([
		// Allow same origin resource loads.
		'self',
		// Allow loading from our assets domain.  Notice the difference between * and **.
		//'http://srv*.assets.example.com/**',
		'https://s3.amazonaws.com/Mindful-Labs/**'
	]);
});

