//
//  SelectioniPhoneTableViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/9/17.
//  Copyright © 2017 epri. All rights reserved.
//

import UIKit

class SelectioniPhoneTableViewController: SelectionTableViewController {

    @IBOutlet weak var closeButton: UIButton!

    @IBAction func closeButtonPressed(_ sender: UIButton) {

        self.dismiss(animated: true,
                     completion: nil)
        
    }
    
}
