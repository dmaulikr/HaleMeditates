module.exports = function(app) {
    var users = require('../../app/controllers/users.server.controller');
    var instructors = require('../../app/controllers/instructors.server.controller');

    // Instructors Routes
    app.route('/instructors')
        .get(instructors.list);
};
