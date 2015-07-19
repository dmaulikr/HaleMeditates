'use strict';

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

/**
 * Instructor Schema
 */
var InstructorSchema = new Schema({
    name: {
        type: String,
        default: '',
        required: 'Please fill Instructor name',
        trim: true
    },
    image: {
        type: String,
        default: '',
        required: 'Please provide image url',
        trim: true
    }
});

mongoose.model('Instructor', InstructorSchema);
