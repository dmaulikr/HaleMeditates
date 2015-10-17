//
//  DateUtil.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class DateUtil {
    
    class func getTimeString(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let str = String(format: "%2d:%02d", hour % 12, minutes)
        let x = (hour < 12) ? str + " PM" : str + " PM";
        return x.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    class func getMonthString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "MMMM";
        return dateFormatter.stringFromDate(date).capitalizedString;
    }
    
    class func getDayOfWeekString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "EEEE";
        return dateFormatter.stringFromDate(date).capitalizedString;
    }
    
    class func getDayOfMonthString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "dd";
        return dateFormatter.stringFromDate(date);
    }
    
    class func getYearFromString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy";
        return dateFormatter.stringFromDate(date);
    }
    
    class func getFullDateString(date: NSDate) -> String {
        return "\(getDayOfWeekString(date)), \(getMonthString(date)) \(getDayOfMonthString(date)), \(getYearFromString(date))";
    }

}
