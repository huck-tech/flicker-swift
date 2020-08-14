//
//  ContributionViewController.swift
//  Flicker
//
//  Created by Anders Melen on 6/10/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ContributionViewController: UIViewController {

    @IBOutlet var contributionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contributionString = ContributionViewController.generateContributionString()
        self.contributionTextView.text = contributionString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    static fileprivate func generateContributionString() -> String {
        
        let contributionPlistPath = Bundle.main.path(forResource: "GraphicalAttribution", ofType: "plist")!
        let contributionData = NSArray(contentsOfFile: contributionPlistPath)!
        
        var string = ""
        
        for individualContribution in contributionData as! [[String : String]] {
            string += "- \(individualContribution["Author"]!) for the \(individualContribution["Use"]!).\n"
        }
        
        return string
    }
}
