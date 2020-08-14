//
//  MainMenuTableViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/16/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

protocol MenuProtocol {
    func menuShouldReturnToRootViewController(_ animated: Bool)
}

class MainMenuTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    fileprivate enum RowData : Int {
        case about = 0
        case contribution
        
        static func count() -> Int {
            
            return contribution.rawValue + 1
        }
        
        func name() -> String {
            var name : String!
            
            if self == .about {
                name = "About"
            } else if self == .contribution {
                name = "Contributions"
            } else {
                assert(false, "No name for RowData \(self)")
            }
            
            return name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.masksToBounds = false

        AppDelegate.rootViewController().menuDelegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return RowData.count() - 1
//        } else {
            return RowData.count()
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let adjustedIndex = indexPath.row
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            adjustedIndex = adjustedIndex + 1
//        }
		
        var cell : MenuTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseID(), for: indexPath) as? MenuTableViewCell

        let rowData = RowData(rawValue: adjustedIndex)!
        cell.configureCell("\(rowData.name())")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let adjustedIndex = indexPath.row
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            adjustedIndex = adjustedIndex + 1
//        }
        
        let rowData = RowData(rawValue: adjustedIndex)
        
        if rowData == .about {
            self.loadAboutViewController()
        } else if rowData == .contribution {
            self.loadContributionViewController()
        } else {
            assert(false, "Unimplemented didSelectRow for \(String(describing: rowData))")
        }
    }

    // MARK: - Loading Sub-Menu View Controllers
    func loadAboutViewController() {
        self.performSegue(withIdentifier: ABOUT_VIEW_CONTROLLER_SEGUE_ID, sender: nil)
    }
    
//    func loadTutorialViewController() {
//        AppDelegate.rootViewController().performSegue(withIdentifier: TUTORIAL_PAGE_VIEW_CONTROLLER_SEGUE_ID, sender: nil)
//        AppDelegate.rootViewController().hideHelpModal(false)
//    }
    
    func loadContributionViewController() {
        self.performSegue(withIdentifier: SHOW_CONTRIBUTION_VIEW_CONTROLLER_SEGUE_ID, sender: nil)
    }
    
}

extension MainMenuTableViewController : MenuProtocol {
    func menuShouldReturnToRootViewController(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
}
