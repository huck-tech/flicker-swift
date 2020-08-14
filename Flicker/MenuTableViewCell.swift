//
//  MenuTableViewCell.swift
//  Flicker
//
//  Created by Anders Melen on 6/6/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var cellLabel: UILabel!
    
    static func reuseID() -> String {
        return MENU_CELL_REUSE_ID
    }
    
    func configureCell(_ title: String) {
        self.cellLabel.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
