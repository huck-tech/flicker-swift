//
//  RootNavigationViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/16/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit
import AVFoundation
import UIImage_Helpers

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBackgroundBlurImage() -> UIImage {
        
        let bounds = self.view.bounds
        
        self.view.layer.masksToBounds = false
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 1)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData = UIImageJPEGRepresentation(screenshot!, 1.0)
        let blurredImage = UIImage(data: imageData!)?.blurredImage(0.1)
        
        var leftAdjustment : CGFloat = 0.0
        
        var menuAdjustment : CGFloat = 0.0
        if AppDelegate.rootViewController().menuContainerTrailingConstraint.constant != 0.0 {
            menuAdjustment += AppDelegate.rootViewController().menuContainerWidthConstraint.constant
        }
        
//        var limitsAdjustment : CGFloat = 0.0
//        if AppDelegate.rootViewController().limitsContainerLeadingConstraint.constant != 0.0 {
//            if UIDevice.current.userInterfaceIdiom == .phone {
//                limitsAdjustment = 0
//            } else {
//                limitsAdjustment = AppDelegate.rootViewController().limitsContainerWidthConstraint.constant
//            }
//        }
        
//        leftAdjustment = fmax(menuAdjustment, limitsAdjustment)
        leftAdjustment = menuAdjustment
        
        let cropRect = CGRect(x: leftAdjustment, y: 64, width: (self.view.bounds.size.width - leftAdjustment), height: self.view.bounds.size.height - 64)
        let croppedCGImage = (blurredImage!.cgImage)?.cropping(to: cropRect)!
        
        let croppedUIImage = UIImage(cgImage: croppedCGImage!)
        
        return croppedUIImage
    }

    // MARK: - Orientation
//    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
//        if let visible = self.visibleViewController as? TutorialPageViewController {
//            return visible.supportedInterfaceOrientations
//        }
//        
//        return super.supportedInterfaceOrientations
//    }
//    
//    override var shouldAutorotate : Bool {
//        if let visible = self.visibleViewController as? TutorialPageViewController {
//            return visible.shouldAutorotate
//        }
//        
//        return super.shouldAutorotate
//    }
//    
//    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
//        
//        if let visible = self.visibleViewController as? TutorialPageViewController {
//            return visible.preferredInterfaceOrientationForPresentation
//        }
//        
//        return super.preferredInterfaceOrientationForPresentation
//    }
}
                                                                          
