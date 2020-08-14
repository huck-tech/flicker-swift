//
//  HeaderView.swift
//  Flicker
//
//  Created by Anders Melen on 5/18/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet var headerLabel: UILabel!

    func configure(_ title: String) {
        self.headerLabel.text = title
    }
}
