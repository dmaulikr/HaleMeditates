//
//  API.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 9/4/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class API {
    
    static var staticPayload: String? {
        get {
            return Util.openResourceFile("payload", ext: "json");
        }
    }
    
    class func getAudioSessions(callback: (Array<AudioSession>?) -> Void) {
        let dataURL =  NSURL(string: Globals.API_ROOT + "/audios");
        let jsonData = NSData(contentsOfURL: dataURL!);
        var dataString: NSString?
        if jsonData == nil {
            if let payload = API.staticPayload {
                dataString = NSString(string: payload);
            }
        } else {
            dataString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding);
        }
        if dataString == nil {
            callback(nil);
            return;
        }
        let utfJsonData = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false);
        
        let parseResult: AnyObject?
        do {
            parseResult = try NSJSONSerialization.JSONObjectWithData(utfJsonData!, options: [])
        } catch _ as NSError {
            parseResult = nil
        };
        if ((parseResult) != nil) {
            let JSONArray =  parseResult! as! NSArray
            var audios: Array<AudioSession> = [];
            
            for audio in JSONArray  {
                let tmpAudio = AudioSession();
                var obj = audio as! [NSObject : AnyObject];
                tmpAudio.duration = Int(ceil(obj["duration"] as! Float));
                let instructor = audio["instructor"] as? NSDictionary;
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
