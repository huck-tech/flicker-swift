//
//  ElectricArcFurnaceViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ElectricArcFurnaceViewController: ProblemBaseViewController {

    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var referenceContainerView: UIView!
    @IBOutlet var resultsContainerView: UIView!
    @IBOutlet var limitsContainerView: UIView!
    
    var electricArcFurnaceInputView: ElectricArcFurnaceInputView!
    var electricArcFurnaceReferenceView: ElectricArcFurnaceReferenceView!
    var electricArcFurnaceResultsView: ElectricArcFurnaceResultsView!
    var limitsContainerViewController: LimitsContainerViewController!

    var padding = 20
    
    // MARK: - View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.electricArcFurnaceInputView = UIView.viewByTypeFromNibNamed(ElectricArcFurnaceViewController.viewNib())
        self.electricArcFurnaceReferenceView = UIView.viewByTypeFromNibNamed(ElectricArcFurnaceViewController.viewNib())
        self.electricArcFurnaceResultsView = UIView.viewByTypeFromNibNamed(ElectricArcFurnaceViewController.viewNib())
        self.limitsContainerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LimitsContainerViewController.storyboardID()) as! LimitsContainerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            AppDelegate.rootViewController().title = "Electric Arc Furnace"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Configuration
    
    override class func viewNib() -> String {
        return ELECTRIC_ARC_FURNACE_VIEWS
    }
    
    override func setupSubViews() {
        self.setupSubView(self.electricArcFurnaceInputView, superView: self.inputContainerView)
        self.electricArcFurnaceInputView.configureView(self)
        
        self.setupSubView(self.electricArcFurnaceReferenceView, superView: self.referenceContainerView, topPadding: 20, bottomPadding: 20, leftPadding: 20, rightPadding: 20)
        self.electricArcFurnaceReferenceView.configureView(self)
        
        self.setupSubView(self.electricArcFurnaceResultsView, superView: self.resultsContainerView, topPadding: 0, bottomPadding: self.padding, leftPadding: self.padding, rightPadding: self.padding)
        self.electricArcFurnaceResultsView.configureView(self)
        
        self.addChildViewController(self.limitsContainerViewController)
        self.limitsContainerViewController.configureView(self)
        self.limitsContainerView.addSubview(self.limitsContainerViewController.view)
        self.limitsContainerViewController.view.applyPaddingToSuperViewConstraints(self.limitsContainerView, padding: 0)
    }
}
