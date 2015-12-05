//
//  API.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 9/4/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static var staticPayload: String? {
        get {
            return Util.openResourceFile("payload", ext: "json");
        }
    }
    
    class func getAudioSessions(callback: (Array<AudioSession>?) -> Void) {
//        let dataURL =  NSURL(string: Globals.API_ROOT + "/audios");
//        let jsonData = NSData(contentsOfURL: dataURL!);
//        var dataString: NSString?
//        if jsonData == nil {
//            if let payload = API.staticPayload {
//                dataString = NSString(string: payload);
//            }
//        } else {
//            dataString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding);
//        }
//        if dataString == nil {
//            callback(nil);
//            return;
//        }
//        let utfJsonData = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false);
//        
//        let parseResult: AnyObject?
//        do {
//            parseResult = try NSJSONSerialization.JSONObjectWithData(utfJsonData!, options: [])
//        } catch _ as NSError {
//            parseResult = nil
//        };
//        if ((parseResult) != nil) {
        
        var audios: Array<AudioSession> = []
        Alamofire.request(.GET, Globals.API_ROOT + "/audios")
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let JSONArray =  JSON as? Array<NSDictionary> {
                        for audio in JSONArray  {
                            let tmpAudio = AudioSession();
                            tmpAudio.duration = Int(ceil(audio["duration"] as! Float));
                            let instructor = audio["instructor"] as? NSDictionary;
                            tmpAudio.instructorImageUrl = instructor?["image"] as? String
                            tmpAudio.instructorName = instructor?["name"] as? String
                            tmpAudio.title = audio["name"] as? String;
                            tmpAudio.audioUrl = audio["file"] as? String;
                            audios.append(tmpAudio);
                        }
                    }
                }
                
                callback(audios);
        }
    }
    
    
    class func getJournals(callback: (Array<JournalEntry>?) -> Void) {
        var entries: Array<JournalEntry> = [];
        Alamofire.request(.GET, Globals.API_ROOT + "/users/me")
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let user = JSON as? NSDictionary {
                        if let journals = user["journals"] as? Array<NSDictionary> {
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ"
                            for journal in journals {
                                let entry = JournalEntry();
                                entry.startDate = dateFormatter.dateFromString(journal["startDate"] as! String);
                                entry.endDate = dateFormatter.dateFromString(journal["endDate"] as! String);
                                entry.entry = journal["entry"] as? String
                                entries.append(entry);
                            }
                        }
                    }
                }
                callback(entries);
        }
    }

}
