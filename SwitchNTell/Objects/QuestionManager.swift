//
//  QuestionManager.swift
//  SwitchNTell
//
//  Created by Caitlin Wang on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation

class QuestionManager {
    
    private static var questionBank: [String] = ["What does a perfect day look like for you?",
                                  "For what in your life do you feel most grateful?",
                                  "What is the greatest accomplishment of your life?",
                                  "Make three true “we” statements.",
                                  "What does friendship mean to you?",
                                  "When did you last cry?",
                                  "What is your most traumatic memory?",
                                  "Who is your role model?",
                                  "What's your favorite color?",
                                  "What’s the meanest thing you’ve ever said to someone?",
                                  "What is your worst habit?",
                                  "What is your biggest pet peeve?",
                                  "What’s the biggest secret you’ve ever kept from your parents?"]

    
    class func getNRandomQuestions(n: Int) -> [String]
    {
        guard n > 0 else { return [] }
        var remaining = questionBank
        var chosen:[String] = []
        for _ in 0 ... n {
            guard !remaining.isEmpty else { break }
            let randomIndex = Int(arc4random_uniform(UInt32(remaining.count)))
            chosen.append(remaining[randomIndex])
            remaining.remove(at: randomIndex)
        }
        return chosen
    }
    
}



