//
//  SelectionTableView.swift
//  Flicker
//
//  Created by Anders Melen on 5/24/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

protocol SelectionTableViewProtocol {
    func didSelectItem(_ item: String, index: Int)
}

class SelectionTableViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    static let STORYBOARD_ID = "selectionTableViewControllerID"
    
    var data = [String]()
    
    var delegate : SelectionTableViewProtocol?
    
    func configure(_ data: [String], selectedIndex: Int?, title: String) {
        self.data = data
        
        self.titleLabel.text = title
        
        self.tableView.reloadData()
        
        if let selectedIndex = selectedIndex {
            self.tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .middle)
        }
    }
}

// MARK: - UITablewView Delegate/DataSource
extension SelectionTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension SelectionTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : MultipleSelectionPopoverTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: MultipleSelectionPopoverTableViewCell.reuseID()) as? MultipleSelectionPopoverTableViewCell
        if cell == nil {
            cell = MultipleSelectionPopoverTableViewCell()
        }
        
        let data = self.data[(indexPath as NSIndexPath).row]
        
        cell.configureCell(data, indexPath: indexPath)
        
        return cell!
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID SELECT ROW \(indexPath)")
        
        let item = self.data[(indexPath as NSIndexPath).row]
        self.delegate?.didSelectItem(item, index: (indexPath as NSIndexPath).row)
    }
}
