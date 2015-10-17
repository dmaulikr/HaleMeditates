//
//  JournalEntry.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class JournalEntry {
    var startDate:NSDate?
    var endDate:NSDate?
    var entry: String?
    
    var startDateString: String? {
        get {
            if let date = startDate {
                let dateFormatter = NSDateFormatter();
                dateFormatter.dateFormat = "MMMM";
                let month = dateFormatter.stringFromDate(date).capitalizedString;
                dateFormatter.dateFormat = "EEEE";
                let dayOfWeek = dateFormatter.stringFromDate(date).capitalizedString;
                dateFormatter.dateFormat = "dd";
                let dayOfMonth = dateFormatter.stringFromDate(date);
                dateFormatter.dateFormat = "yyyy";
                let year = dateFormatter.stringFromDate(date);
                return "\(dayOfWeek), \(month) \(dayOfMonth), \(year)";
            } else {
                return nil;
            }
        }
    }
    
    var getStartTime: String {
        get {
            if let date = startDate {
                return DateUtil.getTimeString(date);
            } else {
                return "";
            }
            
        }
    }
    
    var getEndTime: String {
        get {
            if let date = endDate {
                return DateUtil.getTimeString(date);
            } else {
                return "";
            }
            
        }
    }
    
    var totalTime: String {
        get {
            if (startDate != nil && endDate != nil) {
                let calendar = NSCalendar.currentCalendar()
                let dateComponents = calendar.components(NSCalendarUnit.Second, fromDate: startDate!, toDate: endDate!, options: []);
                let seconds = dateComponents.second;
                return UIUtil.formatTimeString(seconds, longDate: true);
            } else {
                return "";
            }
        }
    }
}
