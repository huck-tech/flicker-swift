//
//  SingleInputView.swift
//  Flicker
//
//  Created by Anders Melen on 5/18/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class SingleInputView: UIView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputContainerView: StyledContainer!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var seperatorView: UIView!
    
    func configureView(_ title: String, value: String, indexPath: IndexPath?, valid: Bool, inputEnabled: Bool = true, showSeperatorView: Bool = true) {
        
        self.layoutIfNeeded()
        
        if valid {
            self.inputContainerView.borderColor = UIColor.lightBlueColor()
        } else {
            self.inputContainerView.borderColor = UIColor.red
        }
        
        self.seperatorView.isHidden = !showSeperatorView
        
        self.inputTextField.isEnabled = inputEnabled
        self.inputTextField.indexPath = indexPath
        
        if inputEnabled {
            self.inputContainerView.backgroundColor = UIColor.darkNavyBlueColor()
        } else {
            self.inputContainerView.borderColor = UIColor.white
            self.inputContainerView.backgroundColor = UIColor.lightNavyBlueColor()
        }
        
        self.titleLabel.text = title
        self.inputTextField.text = value
    }
    
    // Forces Multi-Line UILabel without breaking NSAutolayout Constraints!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subtractedInputContainerWidth = self.frame.size.width - self.inputContainerView.frame.origin.x
        let subtractedLeadingSpace = self.titleLabel.frame.origin.x

        self.titleLabel.preferredMaxLayoutWidth = self.frame.size.width - (subtractedLeadingSpace + subtractedInputContainerWidth)
        
        super.layoutSubviews()
    }
}
