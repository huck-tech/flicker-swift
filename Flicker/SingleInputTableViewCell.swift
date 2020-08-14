//
//  SingleInputTableViewCell.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class SingleInputTableViewCell: UITableViewCell {
    
    var singleInputView: SingleInputView?

    static func reuseID() -> String {
        return SINGLE_INPUT_CELL_REUSE_ID
    }
    
    func configureCell(_ title: String, value: String, indexPath: IndexPath?, valid: Bool, inputEnabled: Bool = true, showSeperatorView: Bool = true) {
        
        if self.singleInputView == nil {
            self.singleInputView = SingleInputView.viewByTypeFromNibNamed(INPUT_VIEWS)
        }
        
        self.singleInputView!.configureView(title, value: value, indexPath: indexPath, valid: valid, inputEnabled: inputEnabled, showSeperatorView: showSeperatorView)
        
        self.contentView.addSubview(self.singleInputView!)

        self.singleInputView!.applyPaddingToSuperViewConstraints(self.contentView, padding: 0)
    }
    
    func makeInputFieldFirstResponder() {
        self.singleInputView?.inputTextField.becomeFirstResponder()
    }
}
