//
//  STOnboardingViewController.swift
//  SwitchNTell
//
//  Created by Bahar Sheikhi on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation
import UIKit

class STOnboardingViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.goButton.setTitleColor(UIColor.white, for: .normal)
        self.goButton.backgroundColor = UIColor.init(red: 236/255, green: 191/255, blue: 0, alpha: 1)
        self.goButton.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.goButton.layer.cornerRadius = 13.0
        
    }
    
    override func viewWillDisappear (_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = nil
    }
    
    
}
