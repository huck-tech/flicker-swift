//
//  MultipleSelectionView.swift
//  Flicker
//
//  Created by Anders Melen on 5/24/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class MultipleSelectionView: UIView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputContainerView: StyledContainer!
    @IBOutlet var selectionButton: UIButton!
    @IBOutlet var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(_ title: String, values: [String], selectedIndex: Int?, indexPath: IndexPath?, valid: Bool, selectionEnabled: Bool = true, showSeperatorView: Bool = true) {

        self.layoutIfNeeded()
        
        if valid {
            self.inputContainerView.borderColor = UIColor.lightBlueColor()
        } else {
            self.inputContainerView.borderColor = UIColor.red
        }
        
        self.seperatorView.isHidden = !showSeperatorView
        
        self.selectionButton.isEnabled = selectionEnabled
        self.selectionButton.indexPath = indexPath
        
        self.titleLabel.text = title
        if let selectedIndex = selectedIndex {
            self.selectionButton.setTitle(values[selectedIndex], for: UIControlState())
        } else {
            self.selectionButton.setTitle("None", for: UIControlState())
        }
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
