'use strict';

//Audios service used to communicate Audios REST endpoints
angular.module('audios').factory('Audios', ['$resource',
	function($resource) {
		return $resource('audios/:audioId', { audioId: '@_id'
		}, {
			update: {
				method: 'PUT'
			}
		});
	}
]);

angular.module('audios').factory('Instructors', ['$resource',
	function($resource) {
		return $resource('instructors/:instructorId', { audioId: '@_id'
		}, {
			update: {
				method: 'PUT'
			}
		});
	}
]);



angular.module('audios').service('fileUpload', ['$http', function ($http) {
	this.uploadFileToUrl = function(file, uploadUrl){
		var fd = new FormData();
		fd.append('file', file);
		return $http.post(uploadUrl, fd, {
			transformRequest: angular.identity,
			headers: {'Content-Type': undefined}
		})
	}
}]);
