'use strict';

angular.module('audios').directive('fileModel', ['$parse', function ($parse) {
	return {
		restrict: 'A',
		link: function(scope, element, attrs) {
			var model = $parse(attrs.fileModel);
			var modelSetter = model.assign;

			element.bind('change', function(){
				scope.$apply(function(){
					modelSetter(scope, element[0].files[0]);
				});
			});
		}
	};
}]);

// Audios controller
angular.module('audios').controller('AudiosController', ['$scope', '$stateParams', '$location', 'Authentication', 'Audios', 'Instructors', 'fileUpload',
	function($scope, $stateParams, $location, Authentication, Audios, Instructors, fileUpload) {
		$scope.authentication = Authentication;

		// Create new Audio
		$scope.createNewInstructor = false;

		$scope.create = function() {
			// Create new Audio object
			var audio = new Audios ({
				name: this.name,
				file: this.audioFile,
				duration: document.getElementsByTagName('audio')[0].duration,
				instructor: (!this.createNewInstructor) ? $scope.instructorId : { name: this.instructorName, image: this.instructorImage }
			});

			// Redirect after save
			audio.$save(function(response) {
				$location.path('audios/' + response._id);

				// Clear form fields
				$scope.name = '';
			}, function(errorResponse) {
				$scope.error = errorResponse.data.message;
			});
		};

		// Remove existing Audio
		$scope.remove = function(audio) {
			if ( audio ) { 
				audio.$remove();

				for (var i in $scope.audios) {
					if ($scope.audios [i] === audio) {
						$scope.audios.splice(i, 1);
					}
				}
			} else {
				$scope.audio.$remove(function() {
					$location.path('audios');
				});
			}
		};

		// Update existing Audio
		$scope.update = function() {
			var audio = $scope.audio;

			audio.$update(function() {
				$location.path('audios/' + audio._id);
			}, function(errorResponse) {
				$scope.error = errorResponse.data.message;
			});
		};

		// Find a list of Audios
		$scope.find = function() {
			$scope.audios = Audios.query(function () {
				debugger;
			});
		};

		$scope.findInstructors = function() {
			$scope.instructors = Instructors.query(function () {
				$scope.createNewInstructor = ($scope.instructors.length === 0) ? true :  $scope.createNewInstructor;
			});
		};

		// Find existing Audio
		$scope.findOne = function() {
			$scope.audio = Audios.get({ 
				audioId: $stateParams.audioId
			});
		};

		$scope.handleSelectInstructor = function(event, instructor) {
			event.preventDefault();
			$scope.instructorImage = instructor.image;
			$scope.instructorName = instructor.name;
			$scope.instructorId = instructor._id;
			console.log(instructor);
		};

		$scope.audioFile = null;

		$scope.uploadFile = function(file, contextToBind){
			console.log('file is ' );
			console.dir(file);
			var uploadUrl = "/fileupload";
			fileUpload.uploadFileToUrl(file, uploadUrl).success(function (data) {
				$scope[contextToBind] = data.url;
			});
		};
	}
]);
