//
//  ProblemBaseViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ProblemBaseViewController: UIViewController {
    
    var isShowingLimitsReference = false
    
    // MARK: - Constructor
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        AppDelegate.rootViewController().flickerLimitReferenceDelegates.append(self)
    }
    
    class func viewNib() -> String {
        preconditionFailure("This method must be overridden!")
    }
    
    // MARK: - SubViews
    func setupSubViews() {
        preconditionFailure("This method must be overridden!")
    }
    
    func setupSubView(_ subView: UIView, superView: UIView, topPadding: Int = 0, bottomPadding: Int = 0, leftPadding: Int = 0, rightPadding: Int = 0) {
        superView.addSubview(subView)
        subView.applyPaddingToSuperViewConstraints(superView,
                                                   topPadding: topPadding,
                                                   bottomPadding: bottomPadding,
                                                   leftPadding: leftPadding,
                                                   rightPadding: rightPadding)
    }
    
    // MARK: - Keyboard
    func keyboardWillShow(_ notification: Notification) { }
    
    func keyboardWillHide() { }
}

//extension ProblemBaseViewController : FlickerLimitsReferenceDiagramProtocol {
//    func showUpdateFlickerLimitsReferenceDiagram(_ showFlickerLimitsDiagram: Bool) {
//        self.isShowingLimitsReference = showFlickerLimitsDiagram
//    }
//}

