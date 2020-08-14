//
//  RepetitiveLoadReferenceView.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class RepetitiveLoadReferenceView: UIView {

    @IBOutlet var imageView: UIImageView!
    
    fileprivate weak var problemBaseViewController : ProblemBaseViewController!
    
    func configureView(_ problemBaseViewController: ProblemBaseViewController) {
        
        self.problemBaseViewController = problemBaseViewController
        
        self.updateReferenceDiagramImage(self.problemBaseViewController.isShowingLimitsReference)
        
        RepetitiveLoadData.sharedInstance.delegates.append(self)
//        AppDelegate.rootViewController().flickerLimitReferenceDelegates.append(self)
    }
    
    fileprivate func updateReferenceDiagramImage(_ showLimits: Bool = false) {
        
        var image: UIImage!

        if showLimits {
            image = UIImage(named: "LimitsReferenceDiagram")
        } else {
            if let shapeType = RepetitiveLoadData.sharedInstance.shapeType {
                let shapeTypeImageName = shapeType.rawValue.replacingOccurrences(of: "\n", with: "")
                image = UIImage(named: shapeTypeImageName)
            }
        }
        
        UIView.transition(with: self.imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
            }, completion: nil)
    }
}

//extension RepetitiveLoadReferenceView : FlickerLimitsReferenceDiagramProtocol {
//    func showUpdateFlickerLimitsReferenceDiagram(_ showFlickerLimitsDiagram: Bool) {
//        self.updateReferenceDiagramImage(showFlickerLimitsDiagram)
//    }
//}

extension RepetitiveLoadReferenceView : RepetitiveLoadProtocol {
    
    func repetitiveLoadDataDidChange() { }
    
    func repetitiveLoadDataDidReset() { }
    
    func shapeTypeDidChange() {
        if self.problemBaseViewController.isShowingLimitsReference == false {
            self.updateReferenceDiagramImage()
        }
    }
}
