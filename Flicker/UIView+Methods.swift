//
//  UIView+Methods.swift
//  Jazz Time
//
//  Created by Anders Melen on 12/8/15.
//  Copyright © 2015 GMSW. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyPaddingToSuperViewConstraints(_ superview: UIView, padding: Int) {
        self.applyPaddingToSuperViewConstraints(superview,
                                                topPadding: padding,
                                                bottomPadding: padding,
                                                leftPadding: padding,
                                                rightPadding: padding)
    }
    
    func applyPaddingToSuperViewConstraints(_ superview: UIView, topPadding: Int, bottomPadding: Int, leftPadding: Int, rightPadding: Int) {
        
        assert(superview.subviews.contains(self), "Subview must be a subview of the superview!")
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Align all directions with 0 padding to superview
        let views : [String : UIView] = ["subView":self,
            "superView":superview]
        let vert = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(topPadding)-[subView]-\(bottomPadding)-|", options: [], metrics: nil, views: views)
        let hor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(leftPadding)-[subView]-\(rightPadding)-|", options: [], metrics: nil, views: views)
        
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += vert
        allConstraints += hor
        NSLayoutConstraint.activate(allConstraints)
        
        self.layoutIfNeeded()
    }
    

}
