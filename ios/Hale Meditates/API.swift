//
//  API.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 9/4/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class API {
    
    class func getAudioSessions(callback: (Array<AudioSession>?) -> Void) {
        var dataURL =  NSURL(string: Globals.API_ROOT + "/audios");
        let jsonData = NSData(contentsOfURL: dataURL!);
        var dataString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String;
        let utfJsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false);
        
        var error : NSError?
            
        let parseResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(utfJsonData!, options: nil, error: &error);
        if ((parseResult) != nil) {
            let JSONArray =  parseResult! as! NSArray
            var audios: Array<AudioSession> = [];
            
            for audio in JSONArray  {
                var tmpAudio = AudioSession();
                var obj = audio as! [NSObject : AnyObject];
                tmpAudio.duration = Int(ceil(obj["duration"] as! Float));
                var instructor = audio["instructor"] as? NSDictionary;
                tmpAudio.instructorImageUrl = instructor?["image"] as? String
                tmpAudio.instructorName = instructor?["name"] as? String
                tmpAudio.title = audio["name"] as? String;
                tmpAudio.audioUrl = audio["file"] as? String;
                audios.append(tmpAudio);
            }
            callback(audios);
        } else {
            callback([]);
        }
    }
}
