//
//  TimeModel.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/10/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class MeditationSettings {
    var prep: Int = 10
    var meditation: Int = 300
    var relax: Int = 60
    
    static let MAX_PREP: Int = 300;
    static let MAX_MEDITATION: Int = 7200;
    static let MAX_RELAX: Int = 300;
    
    static let MIN_PREP: Int = 0;
    static let MIN_MEDITATION: Int = 10;
    static let MIN_RELAX: Int = 0;
    
    class func clone(model: MeditationSettings) -> MeditationSettings {
        let tmp = MeditationSettings();
        tmp.prep = model.prep;
        tmp.meditation = model.meditation;
        tmp.relax = model.relax;
        return tmp;
    }
    
    class func getUsersMeditationSettings() -> MeditationSettings {
        let settings = MeditationSettings();
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let prep: AnyObject? = userDefaults.objectForKey("prep");
        let meditation: AnyObject? = userDefaults.objectForKey("meditation");
        let relax: AnyObject? = userDefaults.objectForKey("relax");
        
        settings.prep = (prep != nil) ? prep as! Int : settings.prep;
        settings.meditation = (meditation != nil) ? meditation as! Int : settings.meditation;
        settings.relax = (relax != nil) ? relax as! Int : settings.relax;
        return settings;
    }
    
    class func saveUsersMeditationSettings(settings: MeditationSettings) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(settings.prep, forKey: "prep")
        userDefaults.setObject(settings.meditation, forKey: "meditation")
        userDefaults.setObject(settings.relax, forKey: "relax")
        userDefaults.synchronize()
    }

}