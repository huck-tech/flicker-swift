//
//  NavigationBarStatusView.swift
//  Flicker
//
//  Created by Anders Melen on 5/18/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class NavigationBarStatusView: UIView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    static func configureView(_ title: String, value: String) -> NavigationBarStatusView {
        
        let statusView : NavigationBarStatusView! = NavigationBarStatusView.viewByTypeFromNibNamed(BAR_BUTTON_ITEM_VIEWS)
        
        statusView.updateTitle(title)
        statusView.updateValue(value)
        
        return statusView
    }
    
    func updateTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    func updateValue(_ value: String) {
        self.valueLabel.text = value
    }
}
