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
    
    class func addJournalEntry(journalEntry: JournalEntry, callback: (success: Bool) -> Void) {
        if journalEntry.startDate == nil || journalEntry.endDate == nil {
            Util.enqueue({ callback(success: false); }, priority: Util.PRIORITY.SUPER_HIGH);
            return;
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let params: [String : AnyObject] = [
            "startDate": dateFormatter.stringFromDate(journalEntry.startDate!),
            "endDate": dateFormatter.stringFromDate(journalEntry.endDate!),
            "entry": journalEntry.entry ?? ""
        ]
        
        Alamofire.request(.POST, Globals.API_ROOT + "/addJournalEntry", parameters: params)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    callback(success: true);
                } else {
                    callback(success: false);
                }
        }
    }
    
    class func editJournalEntry(journalEntry: JournalEntry, callback: (success: Bool) -> Void) {
        let params: [String : AnyObject] = [
            "entry": journalEntry.entry ?? "",
            "_id": journalEntry.id!
        ]
        
        Alamofire.request(.PUT, Globals.API_ROOT + "/editJournalEntry", parameters: params)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    callback(success: true);
                } else {
                    callback(success: false);
                }
        }
    }
    
    class func getAudioSessions(callback: (Array<AudioSession>?) -> Void) {
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
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            for journal in journals {
                                let entry = JournalEntry();
                                entry.startDate = dateFormatter.dateFromString(journal["startDate"] as! String);
                                entry.endDate = dateFormatter.dateFromString(journal["endDate"] as! String);
                                entry.entry = journal["entry"] as? String
                                entry.id = journal["_id"] as? String
                                entries.append(entry);
                            }
                        }
                    }
                }
                
                callback(entries);
        }
    }

}
