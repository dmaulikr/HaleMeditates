//
//  DataContext.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation
import Alamofire

class DataContext {
    
    static var journalEntries: Array<JournalEntry>?
    static var audioSessions: Array<AudioSession>?
    
    class func getJournalEntries(callback: ((Array<JournalEntry>?) -> Void))  {
        
        API.getJournals({(journalEntries: Array<JournalEntry>?) in
            self.journalEntries = journalEntries;
            Util.enqueue(({callback(self.journalEntries);}), priority: Util.PRIORITY.SUPER_HIGH);
        });
        
    }
    
    class func getAudioSessions(callback: (Array<AudioSession>?) -> Void) {
        API.getAudioSessions({ (audioSessions: Array<AudioSession>?) in
            self.audioSessions = audioSessions;
            Util.enqueue(( { callback(self.audioSessions) }), priority: Util.PRIORITY.SUPER_HIGH);
        });
    }
}