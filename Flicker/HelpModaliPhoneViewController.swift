//
//  HelpModaliPhoneViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/10/17.
//  Copyright © 2017 epri. All rights reserved.
//

import UIKit

class HelpModaliPhoneViewController: HelpModalViewController {

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
        AppDelegate.rootViewController().hideHelpModal()
        
    }

}
