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
    var meditation: Int = 600
    var relax: Int = 150
    
    static let MAX_PREP: Int = 300;
    static let MAX_MEDITATION: Int = 7200;
    static let MAX_RELAX: Int = 300;
    
    static let MIN_PREP: Int = 0;
    static let MIN_MEDITATION: Int = 10;
    static let MIN_RELAX: Int = 0;
    
    class func clone(model: MeditationSettings) -> MeditationSettings {
        var tmp = MeditationSettings();
        tmp.prep = model.prep;
        tmp.meditation = model.meditation;
        tmp.relax = model.relax;
        return tmp;
    }
}