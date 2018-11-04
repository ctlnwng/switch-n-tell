//
//  STNumPlayersOnboardingViewController.swift
//  SwitchNTell
//
//  Created by Bahar Sheikhi on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation
import UIKit

class STNumPlayersOnboardingViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var numPlayersTextField: UITextField!
    private var numPlayers: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.numPlayersTextField.delegate = self
        self.numPlayersTextField.keyboardType = .numbersAndPunctuation
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.numPlayersTextField.becomeFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.numPlayers = numPlayersTextField.text
        self.performSegue(withIdentifier: "goToBoardSetup", sender: nil)
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToBoardSetup")
        {
            STSettings.instance().numPlayers = numPlayersTextField.text ?? ""
        }
    }
    
    
}
