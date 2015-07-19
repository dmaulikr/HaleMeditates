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