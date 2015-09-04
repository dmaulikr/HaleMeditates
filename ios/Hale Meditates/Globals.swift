//
//  Globals.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 9/4/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

class Globals {
    
    enum Environment: String {
        case DEV = "DEV"
        case PRODUCTION = "PRODUCTION"
    }
    
    static let environment: Environment = .PRODUCTION;
    static let API_ROOT = (environment == .DEV) ? "http://localhost:3000" : "http://localhost:3000"
    
}