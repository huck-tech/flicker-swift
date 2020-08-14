//
//  LimitsContainerViewController.swift
//  Flicker
//
//  Created by Anders Melen on 6/9/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class LimitsContainerViewController: UIViewController {
    
    @IBOutlet var maxGlobalContributionLabel: UILabel!
    @IBOutlet var emissionLimitLabel: UILabel!
    
    fileprivate weak var problemBaseViewController : ProblemBaseViewController!
    
    static func storyboardID() -> String {
        return "limitsContainerViewStoryboardID"
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateView()
    }
    
    // MARK: - Configuration
    func configureView(_ problemBaseViewController: ProblemBaseViewController) {
        
        self.problemBaseViewController = problemBaseViewController
        
        FlickerLimits.sharedInstance.delegates.append(self)
    }
    
    // MARK: - View Updates
    func updateView() {
        
        self.maxGlobalContributionLabel.text = FlickerLimits.sharedInstance.formattedMaximumGlobalContributionString()
        self.emissionLimitLabel.text = FlickerLimits.sharedInstance.formattedEmissionLimitString()
    }
    
}

extension LimitsContainerViewController : FlickerLimitProtocol {
    func flickerLimitsDidChange() {
        self.updateView()
    }
    
    func flickerLimitsDidReset() {
        self.updateView()
    }
}
