//
//  DataContext.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class DataContext {
    class func getJournalEntries() -> Array<JournalEntry> {
        var e0 = JournalEntry();
        var e1 = JournalEntry();
        var e2 = JournalEntry();
        var e3 = JournalEntry();
        
        
        e0.startDate = NSDate(timeIntervalSinceNow: 13000);
        e1.startDate = NSDate(timeIntervalSinceNow: 151000);
        e2.startDate = NSDate(timeIntervalSinceNow: 1002000);
        e3.startDate = NSDate(timeIntervalSinceNow: 5600);
        
        e0.endDate = NSDate(timeIntervalSinceNow: 10000);
        e1.endDate = NSDate(timeIntervalSinceNow: 150000);
        e2.endDate = NSDate(timeIntervalSinceNow: 1000000);
        e3.endDate = NSDate(timeIntervalSinceNow: 3600);
        
        e0.entry = "This is a bullshit entry. I love meditation";
        e1.entry = "This is a bullshit entry. I loathe meditation";
        e2.entry = "This is a bullshit entry. I hate meditation";
        e3.entry = "This is a bullshit entry. I fuck meditation";
        return [e0, e1, e2, e3];
    }
}