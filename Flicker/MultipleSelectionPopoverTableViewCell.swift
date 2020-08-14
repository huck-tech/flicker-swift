//
//  MultipleSelectionPopoverTableViewCell.swift
//  Flicker
//
//  Created by Anders Melen on 6/8/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class MultipleSelectionPopoverTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.titleLabel.textColor = UIColor(red: 83.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            self.titleLabel.textColor = UIColor.white
        }
    }
    
    static func reuseID() -> String {
        return SELECTION_TABLE_VIEW_CELL_REUSE_ID
    }
    
    // MARK: - Configuration
    func configureCell(_ title: String, indexPath: IndexPath?) {
        self.titleLabel.text = title
        self.indexPath = indexPath
    }
}
