//
//  ElectricArcFurnaceiPhoneViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/8/17.
//  Copyright © 2017 epri. All rights reserved.
//

import UIKit

class ElectricArcFurnaceiPhoneViewController: ElectricArcFurnaceViewController {

    @IBOutlet weak var inputContainerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var segmentedControlContainer: UIView!
    fileprivate var segmentedControl : GMSWSegmentedControl!
    fileprivate var visibleSuvView = VisibleSubView.inputData
    
    override var padding: Int {
        get {
            return 5
        }
        set {
            // nothing
        }
    }
    
    enum VisibleSubView: Int {
        case inputData = 0
        case referenceDiagram = 1
        case results = 2
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSegmentedControl()
        self.updateVisibleSubView()
    }

    // MARK: - Subview Configuration
    // MARK: Segmented Control
    func setupSegmentedControl() {
        
        let theme = GMSWSegmentedControlTheme(highLightColor: UIColor.limitsYellowColor(), backgroundColor: UIColor.lightNavyBlueColor(), seperatorColor: UIColor.darkNavyBlueColor(), textColor: UIColor.white, textFont: UIFont(name: "HelveticaNeue-Thin", size: 20)!)
        self.segmentedControl = GMSWSegmentedControl(frame: CGRect.zero, items: ["Input\nData","Reference\nDiagram","Results"], selectedIndex: self.visibleSuvView.rawValue, theme: theme)
        self.segmentedControl.delegate = self
        self.segmentedControlContainer.addSubview(self.segmentedControl)
        self.segmentedControl.applyPaddingToSuperViewConstraints(self.segmentedControlContainer, padding: 0)
        
    }
    
    func updateVisibleSubView() {
        
        let screenWidth = self.view.frame.size.width
        let newConstraintValue = Int(screenWidth) * self.visibleSuvView.rawValue * -1
        
        UIView.animate(withDuration: 0.2) {
            
            self.inputContainerLeadingConstraint.constant = CGFloat(newConstraintValue)
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
            
        }
    }
}

//MARK: - GMSWSegmentedControl Delegate
extension ElectricArcFurnaceiPhoneViewController : GMSWSegmentedControlDelegate {
    
    func valueDidChange(_ index: Int, item: String) {
        
        guard let visibleSubView = VisibleSubView(rawValue: index) else {
            
            assert(false,
                   "Expected selected index to be a `VisibleSubView`")
            return
            
        }
        
        self.visibleSuvView = visibleSubView
        self.updateVisibleSubView()
        
    }
}
