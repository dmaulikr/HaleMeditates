'use strict';


angular.module('core').controller('HomeController', ['$scope', 'Authentication', '$location',
	function($scope, Authentication, $location) {
		// This provides Authentication context.
		if (!Authentication.user) {
			$location.path('signin');
		}
		$scope.authentication = Authentication;
	}
]);
