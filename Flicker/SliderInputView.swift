//
//  SliderInputView.swift
//  Flicker
//
//  Created by Anders Melen on 6/1/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class SliderInputView: UIView {

    @IBOutlet var slider: UISlider!
    @IBOutlet var inputContainerView: StyledContainer!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var seperatorView: UIView!
    
    func configureView(_ range: (lower: Double, upper: Double), value: Double, indexPath: IndexPath?, valid: Bool, textInputEnabled: Bool = false, showSeperatorView: Bool = true) {
    
        self.layoutIfNeeded()
        
        if valid {
            self.inputContainerView.borderColor = UIColor.white
        } else {
            self.inputContainerView.borderColor = UIColor.red
        }
        
        self.seperatorView.isHidden = !showSeperatorView
        
        self.inputTextField.isEnabled = textInputEnabled
        self.inputTextField.indexPath = indexPath
        
        self.slider.indexPath = indexPath
        self.slider.value = Float(value)
        self.slider.minimumValue = Float(range.lower)
        self.slider.maximumValue = Float(range.upper)
        
        self.updateInputTextViewOnly(value)
    }
    
    func updateInputTextViewOnly(_ value: Double) {
        self.inputTextField.text = String.init(format: "%.2f", value)
    }
}
