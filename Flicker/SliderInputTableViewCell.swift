//
//  SliderInputTableViewCell.swift
//  Flicker
//
//  Created by Anders Melen on 6/1/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class SliderInputTableViewCell: UITableViewCell {

    var sliderInputView: SliderInputView?
    
    var range: (lower: Double, upper: Double)!
    
    static func reuseID() -> String {
        return SLIDER_INPUT_CELL_REUSE_ID
    }
    
    func configureCell(_ range: (lower: Double, upper: Double), value: Double, indexPath: IndexPath?, valid: Bool, textInputEnabled: Bool = false, showSeperatorView: Bool = true) {
        
        self.range = range
        
        if self.sliderInputView == nil {
            self.sliderInputView = SliderInputView.viewByTypeFromNibNamed(INPUT_VIEWS)
        }
        
        self.sliderInputView!.configureView(range, value: value, indexPath: indexPath, valid: valid, textInputEnabled: textInputEnabled, showSeperatorView: showSeperatorView)
        
        self.contentView.addSubview(self.sliderInputView!)

        self.sliderInputView!.applyPaddingToSuperViewConstraints(self.contentView, padding: 0)
    }
    
    func makeInputFieldFirstResponder() {
        self.sliderInputView?.inputTextField.becomeFirstResponder()
    }
    
    func updateInputTextViewOnly(_ value: Double) {
        self.sliderInputView!.updateInputTextViewOnly(value)
    }
}
