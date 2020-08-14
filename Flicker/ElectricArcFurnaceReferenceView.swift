//
//  ElectricArcFurnaceReferenceView.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ElectricArcFurnaceReferenceView: UIView {

    @IBOutlet var imageView: UIImageView!

    fileprivate weak var problemBaseViewController : ProblemBaseViewController!
    
    
    func configureView(_ problemBaseViewController: ProblemBaseViewController) {
        
        self.problemBaseViewController = problemBaseViewController
        
        self.updateReferenceDiagramImage(self.problemBaseViewController.isShowingLimitsReference)
        
//        AppDelegate.rootViewController().flickerLimitReferenceDelegates.append(self)
    }
    
    fileprivate func updateReferenceDiagramImage(_ showLimits: Bool = false) {
        var image: UIImage!
        
        if showLimits {
            image = UIImage(named: "LimitsReferenceDiagram")
        } else {
            image = UIImage(named: "ElectricArcFurnaceReferenceDiagram")
        }
        
        self.imageView.image = image
    }
}

//extension ElectricArcFurnaceReferenceView : FlickerLimitsReferenceDiagramProtocol {
//    func showUpdateFlickerLimitsReferenceDiagram(_ showFlickerLimitsDiagram: Bool) {
//        self.updateReferenceDiagramImage(showFlickerLimitsDiagram)
//    }
//}

