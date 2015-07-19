'use strict';

(function() {
	// Audios Controller Spec
	describe('Audios Controller Tests', function() {
		// Initialize global variables
		var AudiosController,
		scope,
		$httpBackend,
		$stateParams,
		$location;

		// The $resource service augments the response object with methods for updating and deleting the resource.
		// If we were to use the standard toEqual matcher, our tests would fail because the test values would not match
		// the responses exactly. To solve the problem, we define a new toEqualData Jasmine matcher.
		// When the toEqualData matcher compares two objects, it takes only object properties into
		// account and ignores methods.
		beforeEach(function() {
			jasmine.addMatchers({
				toEqualData: function(util, customEqualityTesters) {
					return {
						compare: function(actual, expected) {
							return {
								pass: angular.equals(actual, expected)
							};
						}
					};
				}
			});
		});

		// Then we can start by loading the main application module
		beforeEach(module(ApplicationConfiguration.applicationModuleName));

		// The injector ignores leading and trailing underscores here (i.e. _$httpBackend_).
		// This allows us to inject a service but then attach it to a variable
		// with the same name as the service.
		beforeEach(inject(function($controller, $rootScope, _$location_, _$stateParams_, _$httpBackend_) {
			// Set a new global scope
			scope = $rootScope.$new();

			// Point global variables to injected services
			$stateParams = _$stateParams_;
			$httpBackend = _$httpBackend_;
			$location = _$location_;

			// Initialize the Audios controller.
			AudiosController = $controller('AudiosController', {
				$scope: scope
			});
		}));

		it('$scope.find() should create an array with at least one Audio object fetched from XHR', inject(function(Audios) {
			// Create sample Audio using the Audios service
			var sampleAudio = new Audios({
				name: 'New Audio'
			});

			// Create a sample Audios array that includes the new Audio
			var sampleAudios = [sampleAudio];

			// Set GET response
			$httpBackend.expectGET('audios').respond(sampleAudios);

			// Run controller functionality
			scope.find();
			$httpBackend.flush();

			// Test scope value
			expect(scope.audios).toEqualData(sampleAudios);
		}));

		it('$scope.findOne() should create an array with one Audio object fetched from XHR using a audioId URL parameter', inject(function(Audios) {
			// Define a sample Audio object
			var sampleAudio = new Audios({
				name: 'New Audio'
			});

			// Set the URL parameter
			$stateParams.audioId = '525a8422f6d0f87f0e407a33';

			// Set GET response
			$httpBackend.expectGET(/audios\/([0-9a-fA-F]{24})$/).respond(sampleAudio);

			// Run controller functionality
			scope.findOne();
			$httpBackend.flush();

			// Test scope value
			expect(scope.audio).toEqualData(sampleAudio);
		}));

		it('$scope.create() with valid form data should send a POST request with the form input values and then locate to new object URL', inject(function(Audios) {
			// Create a sample Audio object
			var sampleAudioPostData = new Audios({
				name: 'New Audio'
			});

			// Create a sample Audio response
			var sampleAudioResponse = new Audios({
				_id: '525cf20451979dea2c000001',
				name: 'New Audio'
			});

			// Fixture mock form input values
			scope.name = 'New Audio';

			// Set POST response
			$httpBackend.expectPOST('audios', sampleAudioPostData).respond(sampleAudioResponse);

			// Run controller functionality
			scope.create();
			$httpBackend.flush();

			// Test form inputs are reset
			expect(scope.name).toEqual('');

			// Test URL redirection after the Audio was created
			expect($location.path()).toBe('/audios/' + sampleAudioResponse._id);
		}));

		it('$scope.update() should update a valid Audio', inject(function(Audios) {
			// Define a sample Audio put data
			var sampleAudioPutData = new Audios({
				_id: '525cf20451979dea2c000001',
				name: 'New Audio'
			});

			// Mock Audio in scope
			scope.audio = sampleAudioPutData;

			// Set PUT response
			$httpBackend.expectPUT(/audios\/([0-9a-fA-F]{24})$/).respond();

			// Run controller functionality
			scope.update();
			$httpBackend.flush();

			// Test URL location to new object
			expect($location.path()).toBe('/audios/' + sampleAudioPutData._id);
		}));

		it('$scope.remove() should send a DELETE request with a valid audioId and remove the Audio from the scope', inject(function(Audios) {
			// Create new Audio object
			var sampleAudio = new Audios({
				_id: '525a8422f6d0f87f0e407a33'
			});

			// Create new Audios array and include the Audio
			scope.audios = [sampleAudio];

			// Set expected DELETE response
			$httpBackend.expectDELETE(/audios\/([0-9a-fA-F]{24})$/).respond(204);

			// Run controller functionality
			scope.remove(sampleAudio);
			$httpBackend.flush();

			// Test array after successful delete
			expect(scope.audios.length).toBe(0);
		}));
	});
}());