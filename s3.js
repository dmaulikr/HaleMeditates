'use strict';
/**
 * Module dependencies.
 */
var AWS = require('aws-sdk');
var fs = require('fs');

AWS.config.update({
	accessKeyId: 'AKIAI3D37MRQJM3GQ5AA',
	secretAccessKey: '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'
});

var s3 = new AWS.S3();

// var s3bucket = new AWS.S3({params: {Bucket: 'Mindful-Labs/meditation-audio'}});

// s3bucket.createBucket(function() {
//   var params = {Key: 'myKey', Body: 'Hello!'};
//   s3bucket.upload(params, function(err, data) {
//     if (err) {
//       console.log("Error uploading data: ", err);
//     } else {
//       console.log("Successfully uploaded data to myBucket/myKey\n", data);
//     }
//   });
// });

//var fileName = 'server.js';
//var filePath = './' + fileName;
//var fileKey = fileName;
//var buffer = fs.readFileSync('./' + filePath);
// S3 Upload options
var bucket = 'Mindful-Labs/meditation-audio';


module.exports = {
  uploadFile: function (fileKey, buffer, contentType, callback) {
    function completeMultipartUpload(s3, doneParams) {
      s3.completeMultipartUpload(doneParams, function(err, data) {
        if (err) {
          console.log("An error occurred while completing the multipart upload");
          console.log(err);
          callback(err, data);
        } else {
          var delta = (new Date() - startTime) / 1000;
          console.log('Completed upload in', delta, 'seconds');
          console.log('Final upload data:', data);
          callback(null, data);
        }
      });
    }

    function uploadPart(s3, multipart, partParams, tryNum) {
      var tryNum = tryNum || 1;
      s3.uploadPart(partParams, function(multiErr, mData) {
        if (multiErr){
          console.log('multiErr, upload part error:', multiErr);
          if (tryNum < maxUploadTries) {
            console.log('Retrying upload of part: #', partParams.PartNumber)
            uploadPart(s3, multipart, partParams, tryNum + 1);
          } else {
            console.log('Failed uploading part: #', partParams.PartNumber)
          }
          return;
        }
        multipartMap.Parts[this.request.params.PartNumber - 1] = {
          ETag: mData.ETag,
          PartNumber: Number(this.request.params.PartNumber)
        };
        console.log("Completed part", this.request.params.PartNumber);
        console.log('mData', mData);
        if (--numPartsLeft > 0) return; // complete only when all parts uploaded

        var doneParams = {
          Bucket: bucket,
          Key: fileKey,
          MultipartUpload: multipartMap,
          UploadId: multipart.UploadId
        };

        console.log("Completing upload...");
        completeMultipartUpload(s3, doneParams);
      });
    }

    var startTime = new Date();
    var partNum = 0;
    var partSize = 1024 * 1024 * 5; // Minimum 5MB per chunk (except the last part) http://docs.aws.amazon.com/AmazonS3/latest/API/mpUploadComplete.html
    var numPartsLeft = Math.ceil(buffer.length / partSize);
    var maxUploadTries = 3;
    var multiPartParams = {
      Bucket: bucket,
      Key: fileKey,
      ContentType: contentType,
      ACL: 'public-read'
    };
    var multipartMap = {
      Parts: []
    };

    console.log("Creating multipart upload for:", fileKey);
    s3.createMultipartUpload(multiPartParams, function(mpErr, multipart){
      if (mpErr) { console.log('Error!', mpErr); return; }
      console.log("Got upload ID", multipart.UploadId);

      // Grab each partSize chunk and upload it as a part
      for (var rangeStart = 0; rangeStart < buffer.length; rangeStart += partSize) {
        partNum++;
        var end = Math.min(rangeStart + partSize, buffer.length),
            partParams = {
              Body: buffer.slice(rangeStart, end),
              Bucket: bucket,
              Key: fileKey,
              PartNumber: String(partNum),
              UploadId: multipart.UploadId
            };

        // Send a single part
        console.log('Uploading part: #', partParams.PartNumber, ', Range start:', rangeStart);
        uploadPart(s3, multipart, partParams);
      }
    });

  }
};