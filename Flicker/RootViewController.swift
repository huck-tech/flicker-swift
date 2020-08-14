//
//  RootViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/16/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

//protocol FlickerLimitsReferenceDiagramProtocol {
//    func showUpdateFlickerLimitsReferenceDiagram(_ showFlickerLimitsDiagram: Bool)
//}

class RootViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var resetButton: UIBarButtonItem!
    
    @IBOutlet var limitsContainerLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet var limitsContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var menuContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var menuContainerTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var helpContainer: UIView!
    
//    @IBOutlet var flickerLimitsButton: UIBarButtonItem!
    
    var menuDelegate : MenuProtocol?
    
//    var flickerLimitReferenceDelegates = [FlickerLimitsReferenceDiagramProtocol]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

#if DEBUG
        var alertMessage = "Flicker Evaluation Module – Beta (FEM-Beta) \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)\n"
        alertMessage += "Electric Power Research Institute (EPRI)\n"
        alertMessage += "3420 Hillview Ave.\nPalo Alto, CA 94304\n\n"
        alertMessage += "Copyright © 2016 - 2018 Electric Power Research Institute, Inc. All rights reserved.\n\n"
        alertMessage += "As a user of this EPRI beta software, you accept and acknowledge that:\n\n"
            
        alertMessage += "• This software is a beta version which may have problems that could potentially harm your system\n"
        alertMessage += "• To satisfy the terms and conditions of the Master License Agreement or Beta License Agreement between EPRI and your company, you understand what to do with this beta product after the beta review period has expired\n"
        alertMessage += "• Reproduction or distribution of this beta software is in violation of the terms and conditions of the Master License Agreement or Beta License Agreement currently in place between EPRI and your company\n"
        alertMessage += "• Your company's funding will determine if you have the rights to the final production release of this product\n"
        alertMessage += "• EPRI will evaluate all tester suggestions and recommendations, but does not guarantee they will be incorporated into the final production product\n"
        alertMessage += "• As a beta tester, you agree to provide feedback as a condition of obtaining the preproduction software\n"
        
        let alert = UIAlertController(title: "Preproduction Acceptance Required", message: alertMessage, preferredStyle: .alert)

        
        let acceptAction = UIAlertAction(title: "I Accept", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(acceptAction)
        
        self.present(alert, animated: true, completion: nil)
#endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if RootViewController.isFirstLaunch() {
            RootViewController.saveFirstLaunchInformation()

// TODO - Remove tutorial
//            if UIDevice.current.userInterfaceIdiom != .phone {
//                self.showTutorial()
//            }
        }
        
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.showLimitsModal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - First Launch
    static func isFirstLaunch() -> Bool {
        
        if let firstLaunch = UserDefaults.standard.object(forKey: "FirstLaunch") as? Bool {
            if firstLaunch == true {
                return true
            } else {
                return false
            }
        }
        
        return true
    }
    
    static func saveFirstLaunchInformation() {
        UserDefaults.standard.set(false, forKey: "FirstLaunch")
        UserDefaults.standard.synchronize()
    }
    
//    func showTutorial() {
//        self.menuViewController()?.loadTutorialViewController()
//    }
    
    // MARK: - Limits Modal
    
//    func toggleLimitsModal() {
//        
//        self.hideHelpModal()
//        self.hideMenuModal()
//        
//        if self.limitsContainerLeadingConstraint.constant == 0 {
//            self.showLimitsModal()
//        } else {
//            self.hideLimitsModal()
//        }
//    }
    
//    func showLimitsModal() {
    
//        self.showLimitsReferenceDiagram()
        
//        self.flickerLimitsButton.title = "Hide Limits"
        
//        self.limitsContainerLeadingConstraint.constant = self.limitsContainerWidthConstraint.constant
//
//        UIView.animate(withDuration: 0.2, animations: { 
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//    }
    
//    func hideLimitsModal() {
    
//        self.hideLimitsReferenceDiagram()
        
//        self.flickerLimitsButton.title = "Show Limits"
        
//        self.limitsContainerLeadingConstraint.constant = 0
//        UIView.animate(withDuration: 0.2, animations: {
//            self.view.layoutIfNeeded()
//        }) 
//    }
    
//    func showLimitsReferenceDiagram() {
//        for delegate in self.flickerLimitReferenceDelegates {
//            delegate.showUpdateFlickerLimitsReferenceDiagram(true)
//        }
//    }
//    
//    func hideLimitsReferenceDiagram() {
//        for delegate in self.flickerLimitReferenceDelegates {
//            delegate.showUpdateFlickerLimitsReferenceDiagram(false)
//        }
//    }
    
    // MARK: - Menu Modal
    
    func menuViewController() -> MainMenuTableViewController? {
        
        for childVC in self.childViewControllers {
            if let menuNav = childVC as? UINavigationController {
                if let mainMenu = menuNav.viewControllers.first as? MainMenuTableViewController {
                    return mainMenu
                }
            }
        }
        
        assert(false, "Should always find MainMenuTableViewController in childViewControllers!")
        return nil
    }
    
    func toggleMenuModal() {
        
        self.hideHelpModal()
//        self.hideLimitsModal()
        
        if self.menuContainerTrailingConstraint.constant == 0 {
            self.showMenuModal()
        } else {
            self.hideMenuModal()
        }
    }
    
    func showMenuModal(_ animated: Bool = true) {
        
        let duration = (animated == true) ? 0.2 : 0.0
        
        self.menuContainerTrailingConstraint.constant = self.menuContainerWidthConstraint.constant
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    func hideMenuModal(_ animated: Bool = true) {
        
        let duration = (animated == true) ? 0.2 : 0.0
        
        self.menuContainerTrailingConstraint.constant = 0
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    // Mark: - UIBarButton Items
    
//    @IBAction func limitsButtonPressed(_ sender: UIBarButtonItem) {
//        self.toggleLimitsModal()
//    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        self.toggleMenuModal()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController.init(title: "Reset All Values?", message: "This will erase all values giving you a fresh start. Would you like to continue?", preferredStyle: .alert)
        let continueButton = UIAlertAction(title: "Reset", style: UIAlertActionStyle.destructive) { (action) in
            self.refreshValues()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(continueButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Help Modal
    func toggleHelpModal() {
        if self.helpContainer.isHidden == true {
            self.showHelpModal()
        } else {
            self.hideHelpModal()
        }
    }
    
    func showHelpModal() {
        
        self.hideMenuModal(false)
        
        self.helpContainer.alpha = 0.0
        self.helpContainer.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { 
            self.helpContainer.alpha = 1.0
        }) 
    }
    
    func hideHelpModal(_ animated: Bool = true) {
        
        self.menuDelegate?.menuShouldReturnToRootViewController(animated)
        
        let animationDuration = (animated == true) ? 0.2 : 0.0
        
        self.helpContainer.alpha = 1.0
        UIView.animate(withDuration: animationDuration, animations: {
            self.helpContainer.alpha = 0.0
            }, completion: { (finished) in
                if finished {
                    self.helpContainer.isHidden = true
                }
        }) 
    }
    
    // MARK: - Refresh Button
    fileprivate func refreshValues() {
        FlickerLimits.sharedInstance.reset()
        RepetitiveLoadData.sharedInstance.reset()
        ElectricArcFurnaceData.sharedInstance.reset()
    }
}
