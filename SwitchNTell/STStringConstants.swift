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
        return "Setup the board by creating your grid--tap on four dots to represent the four corners of the room."
    }
    
    static func getGamePlayInstructions() -> String {
        return "Your team has \(STSettings.instance().numPlayers) moves. Once you are done please press the Shuffle button to see who is in the hot seat 🔥."
    }
    
}
