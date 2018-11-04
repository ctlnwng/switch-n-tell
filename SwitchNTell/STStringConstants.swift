//
//  STStringConstants.swift
//  SwitchNTell
//
//  Created by Bahar Sheikhi on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation

class STStringConstants {

    static func getSetupBoardInstructions() -> String {
        return "After a grid is detected, tap to create the four corners of your game board!"
    }
    
    static func getGamePlayInstructions() -> String {
        return "Your team can switch questions between players \(STSettings.instance().numPlayers) times. Afterwards, press the Shuffle button to see who's in the hot seat 🔥."
    }
    
}
