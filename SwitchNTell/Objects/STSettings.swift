//
//  STSettings.swift
//  SwitchNTell
//
//  Created by Bahar Sheikhi on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation

class STSettings {
    
    var numPlayers: String = "0"
    
    private static var sharedSettings: STSettings = {
        let settings = STSettings()
        return settings
    }()
    
    class func instance() -> STSettings
    {
        return sharedSettings
    }
    
}
