//
//  RepetitiveLoadViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class RepetitiveLoadViewController: ProblemBaseViewController {

    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var referenceContainerView: UIView!
    @IBOutlet var resultsContainerView: UIView!
    @IBOutlet var limitsContainerView: UIView!
    
    @IBOutlet var inputContainerButtonConstraint: NSLayoutConstraint!
    
    var repetitiveLoadInputView: RepetitiveLoadInputView!
    var repetitiveLoadReferenceView: RepetitiveLoadReferenceView!
    var repetitiveLoadResultsView: RepetitiveLoadResultsView!
    var limitsContainerViewController: LimitsContainerViewController!
    
    var padding = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            AppDelegate.rootViewController().title = "Repetitive Load"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - View Configuration
    
    override class func viewNib() -> String {
        return REPETITIVE_LOAD_VIEWS
    }
    
    override func setupSubViews() {
        
        self.repetitiveLoadInputView = UIView.viewByTypeFromNibNamed(RepetitiveLoadViewController.viewNib())
        self.repetitiveLoadReferenceView = UIView.viewByTypeFromNibNamed(RepetitiveLoadViewController.viewNib())
        self.repetitiveLoadResultsView = UIView.viewByTypeFromNibNamed(RepetitiveLoadViewController.viewNib())
        self.limitsContainerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LimitsContainerViewController.storyboardID()) as! LimitsContainerViewController
        
        self.setupSubView(self.repetitiveLoadInputView, superView: self.inputContainerView)
        self.repetitiveLoadInputView.configureView(self)
        
        self.setupSubView(self.repetitiveLoadReferenceView, superView: self.referenceContainerView, topPadding: 20, bottomPadding: 20, leftPadding: 20, rightPadding: 20)
        self.repetitiveLoadReferenceView.configureView(self)
        
        self.setupSubView(self.repetitiveLoadResultsView, superView: self.resultsContainerView, topPadding: 0, bottomPadding: self.padding, leftPadding: self.padding, rightPadding: self.padding)
        self.repetitiveLoadResultsView.configureView(self)
        
        self.addChildViewController(self.limitsContainerViewController)
        self.limitsContainerViewController.configureView(self)
        self.limitsContainerView.addSubview(self.limitsContainerViewController.view)
        self.limitsContainerViewController.view.applyPaddingToSuperViewConstraints(self.limitsContainerView, padding: 0)
    }
    
    // MARK: - Keyboard
    override func keyboardWillShow(_ notification: Notification) {
        
        let info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.view.layoutIfNeeded()
        self.inputContainerButtonConstraint.constant = keyboardFrame.size.height - 49 // subtract tab bar height
        
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }
    
    override func keyboardWillHide() {
        
        self.inputContainerButtonConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
