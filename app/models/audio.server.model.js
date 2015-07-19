'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
	Schema = mongoose.Schema;

/**
 * Audio Schema
 */
var AudioSchema = new Schema({
	name: {
		type: String,
		default: '',
		required: 'Please fill Audio name',
		trim: true
	},
	file: {
		type: String,
		default: '',
		required: 'Please provide file name',
		trim: true
	},
	duration: {
		type: Number,
		default: 0
	},
	instructor: {
		type: Schema.ObjectId,
		ref: 'Instructor',
		required: 'Please provide an instructor'
	},
	created: {
		type: Date,
		default: Date.now
	},
	user: {
		type: Schema.ObjectId,
		ref: 'User'
	}
});

mongoose.model('Audio', AudioSchema);
