//
//  MultipleSelectionTableViewCell.swift
//  Flicker
//
//  Created by Anders Melen on 5/24/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class MultipleSelectionTableViewCell: UITableViewCell {
    
    var multipleSelectionView: MultipleSelectionView?
    
    static func reuseID() -> String {
        return MULTIPLE_SELECTION_CELL_REUSE_ID
    }
    
    
    func configureCell(_ title: String, values: [String], selectedIndex: Int?, indexPath: IndexPath?, valid: Bool, selectionEnabled: Bool = true, showSeperatorView: Bool = true) {
        
        if self.multipleSelectionView == nil {
            self.multipleSelectionView = MultipleSelectionView.viewByTypeFromNibNamed(INPUT_VIEWS)
        }
        
        self.multipleSelectionView!.configureView(title, values: values, selectedIndex: selectedIndex, indexPath: indexPath, valid: valid, selectionEnabled: selectionEnabled, showSeperatorView: showSeperatorView)

        self.contentView.addSubview(self.multipleSelectionView!)
        
        self.multipleSelectionView?.applyPaddingToSuperViewConstraints(self.contentView, padding: 0)
    }
}
