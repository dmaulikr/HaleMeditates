//
//  UIUtil.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/18/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation
import UIKit

class UIUtil {
    
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static func getViewControllerFromStoryboard(name: String) -> AnyObject! {
        return storyboard.instantiateViewControllerWithIdentifier(name)
    }
    
    static let primaryColor = UIColor(red: 80 / 256, green: 210 / 256, blue: 194 / 256, alpha: 1)
    static let secondaryColor = UIColor(red: 132 / 256, green: 128 / 256, blue: 240 / 256, alpha: 1)
    static let tertiaryColor = UIColor(red: 252 / 256, green: 171 / 256, blue: 83 / 256, alpha: 1)
    
    static func formatTimeString(value: Int, longDate: Bool = false) -> String {
        if (longDate) {
            return formatTimeStringLong(value);
        }
        // long date not supported at the moment
        var minutes: Int = value / 60
        var seconds: Int = value - (minutes * 60);
        if ((minutes > 0 && seconds > 0) || minutes >= 60) {
            if (minutes < 10) {
                return NSString(format: "%dm%02ds", minutes, seconds) as! String
            } else if (minutes < 60) {
                return "\(minutes)m";
            } else {
                var hours: Int = minutes / 60
                minutes = minutes - (hours * 60);
                if (minutes > 0) {
                    return NSString(format: "%dh%02dm", hours, minutes) as! String
                } else {
                    return "\(hours)h";
                }
            }
        } else if (minutes > 0 ){
            return "\(minutes)m";
        } else {
            return "\(seconds)s";
        }
    }
    
    static func formatTimeStringLong(value: Int) -> String {
        var minutes: Int = value / 60
        var m = ((minutes % 60) == 1) ? "minute" : "minutes";
        var seconds: Int = value - (minutes * 60);
        var s = ((seconds % 60) == 1) ? "second" : "seconds";
        if ((minutes > 0 && seconds > 0) || minutes >= 60) {
            if (minutes < 10) {
                return NSString(format: "%d \(m)%02d \(s)", minutes, seconds) as! String
            } else if (minutes < 60) {
                return "\(minutes) \(m)";
            } else {
                var hours: Int = minutes / 60
                var h = ((hours % 24) == 1) ? "hour" : "hours";
                minutes = minutes - (hours * 60);
                if (minutes > 0) {
                    return NSString(format: "%d \(h)%02d \(m)", hours, minutes) as! String
                } else {
                    return "\(hours) \(h)";
                }
            }
        } else if (minutes > 0 ){
            return "\(minutes) \(m)";
        } else {
            return "\(seconds) \(s)";
        }
    }
}
