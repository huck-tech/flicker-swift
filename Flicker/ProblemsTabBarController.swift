//
//  ProblemsTabBarController.swift
//  Flicker
//
//  Created by Anders Melen on 5/16/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ProblemsTabBarController: UITabBarController {

    enum FlickerProblem : Int {
		case flickerLimits = 0
        case repetitiveLoad
        case electricArcFurnace
    }
    
    var currentProblem : FlickerProblem {
        return FlickerProblem(rawValue: self.selectedIndex)!
    }
    
    func flickerProblemViewController<T>() -> T? {
        
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let foundViewController = viewController as? T {
                    return foundViewController
                }
            }
        }
        
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
