//
//  RootiPhoneViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/9/17.
//  Copyright © 2017 epri. All rights reserved.
//

import UIKit

class RootiPhoneViewController: RootViewController {

    @IBOutlet var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.hideDoneButton()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {

        AppDelegate.rootViewController().view.endEditing(true)
        
    }
    
    func showDoneButton() {
      
        AppDelegate.rootViewController().navigationItem.setRightBarButtonItems([self.resetButton,self.doneButton], animated: true)
        
    }
    
    func hideDoneButton() {
        
        AppDelegate.rootViewController().navigationItem.setRightBarButtonItems([self.resetButton], animated: true)
        
    }
    
    override func showMenuModal(_ animated: Bool) {
        
        let duration = (animated == true) ? 0.2 : 0.0
        
        self.menuContainerTrailingConstraint.constant = self.view.frame.width
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
        
    }

//    override func showLimitsModal() {
    
//        self.showLimitsReferenceDiagram()

//        self.flickerLimitsButton.title = ""
		
//        self.limitsContainerLeadingConstraint.constant = self.view.frame.width
//        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
	
}
