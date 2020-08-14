//
//  ElectricArcFurnaceResultsView.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ElectricArcFurnaceResultsView: UIView {

    fileprivate weak var problemBaseViewController : ProblemBaseViewController!
    
    @IBOutlet var flickerSeverityFactorLowerLabel: UILabel!
    @IBOutlet var flickerSeverityFactorHigherLabel: UILabel!
    
    @IBOutlet var pstDueToLoadAtPCCLowerLabel: UILabel!
    @IBOutlet var pstDueToLoadAtPCCHigherLabel: UILabel!

    @IBOutlet var overallPstAtPCCLowerLabel: UILabel!
    @IBOutlet var overallPstAtPCCHigherLabel: UILabel!
    
    @IBOutlet var overallPstAtUSBusLowerLabel: UILabel!
    @IBOutlet var overallPstAtUSBusHigherLabel: UILabel!
    
    @IBOutlet var maxSizePstDueToLoadAtPCCLabel: UILabel!
    @IBOutlet var maxSizeOverallPstAtPCCLabel: UILabel!
    
    @IBOutlet var errorsButton: UIButton!
    
    func configureView(_ problemBaseViewController: ProblemBaseViewController) {
        self.problemBaseViewController = problemBaseViewController
        
        ElectricArcFurnaceData.sharedInstance.delegates.append(self)
        FlickerLimits.sharedInstance.delegates.append(self)
        
        self.updateView()
    }
    
    fileprivate func updateView() {
        self.updateResultLabelValues()
        self.updateResultLabelColors()
        
        self.updateErrorsButton()
    }
    
    fileprivate func updateErrorsButton() {
        let electricArcFurnaceMissingInputs = ElectricArcFurnaceData.sharedInstance.missingInputs()
        let flickerLimitsMissingInputs = FlickerLimits.sharedInstance.missingInputs()
        
        self.errorsButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if electricArcFurnaceMissingInputs.count > 0 || flickerLimitsMissingInputs.count > 0 {
            self.errorsButton.setTitle("\(electricArcFurnaceMissingInputs.count + flickerLimitsMissingInputs.count)", for: UIControlState())
            self.errorsButton.setTitle("\(electricArcFurnaceMissingInputs.count + flickerLimitsMissingInputs.count)", for: .highlighted)
            self.errorsButton.setBackgroundImage(UIImage(named: "InvalidInputsButton"), for: UIControlState())
            self.errorsButton.setBackgroundImage(UIImage(named: "InvalidInputsButton-Selected"), for: .highlighted)
            self.errorsButton.addTarget(self, action: #selector(missingInputsButtonPressed), for: .touchUpInside)
        } else if ElectricArcFurnaceData.sharedInstance.withinLimits() == false {
            self.errorsButton.setTitle("", for: UIControlState())
            self.errorsButton.setTitle("", for: .highlighted)
            self.errorsButton.setBackgroundImage(UIImage(named: "FlickerOutsideOfLimitsButton"), for: UIControlState())
            self.errorsButton.setBackgroundImage(UIImage(named: "FlickerOutsideOfLimitsButton-Selected"), for: .highlighted)
            self.errorsButton.addTarget(self, action: #selector(outsideOfLimitsButtonPressed), for: .touchUpInside)
        } else {
            self.errorsButton.setTitle("", for: UIControlState())
            self.errorsButton.setTitle("", for: .highlighted)
            self.errorsButton.setBackgroundImage(UIImage(named: "FlickerWithinLimitsButton"), for: UIControlState())
            self.errorsButton.setBackgroundImage(UIImage(named: "FlickerWithinLimitsButton-Selected"), for: .highlighted)
            self.errorsButton.addTarget(self, action: #selector(withinLimitsButtonPressed), for: .touchUpInside)
        }
    }
    
    fileprivate func updateResultLabelValues() {
        
        let resultsViewEmptyValue = "---"
        
        self.flickerSeverityFactorLowerLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.flickerSeverityFactorLower, emptyValue: resultsViewEmptyValue)
        self.flickerSeverityFactorHigherLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.flickerSeverityFactorHigher)
        
        self.pstDueToLoadAtPCCLowerLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.pstDueToLoadAtPCCLower, emptyValue: resultsViewEmptyValue)
        self.pstDueToLoadAtPCCHigherLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.pstDueToLoadAtPCCHigher, emptyValue: resultsViewEmptyValue)
        
        self.overallPstAtPCCLowerLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.overallPstAtPCCLower, emptyValue: resultsViewEmptyValue)
        self.overallPstAtPCCHigherLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.overallPstAtPCCHigher, emptyValue: resultsViewEmptyValue)
        
        self.overallPstAtUSBusLowerLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.overallPstAtUSBusLower, emptyValue: resultsViewEmptyValue)
        self.overallPstAtUSBusHigherLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.overallPstAtUSBusHigher, emptyValue: resultsViewEmptyValue)
        
        self.maxSizePstDueToLoadAtPCCLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.maxSizePstDueToLoadAtPCC, emptyValue: resultsViewEmptyValue)
        self.maxSizeOverallPstAtPCCLabel.text = ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.maxSizeOverallPstAtPCC, emptyValue: resultsViewEmptyValue)
    }
    
    fileprivate func updateResultLabelColors() {
        
        if ElectricArcFurnaceData.sharedInstance.pstDueToLoadAtPCCLowerValid() {
            self.pstDueToLoadAtPCCLowerLabel.textColor = UIColor.validGreenColor()
        } else {
            self.pstDueToLoadAtPCCLowerLabel.textColor = UIColor.errorRedColor()
        }
        
        if ElectricArcFurnaceData.sharedInstance.pstDueToLoadAtPCCHigherValid() {
            self.pstDueToLoadAtPCCHigherLabel.textColor = UIColor.validGreenColor()
        } else {
            self.pstDueToLoadAtPCCHigherLabel.textColor = UIColor.errorRedColor()
        }
        
        if ElectricArcFurnaceData.sharedInstance.overallPstAtPCCLowerValid() {
            self.overallPstAtPCCLowerLabel.textColor = UIColor.validGreenColor()
        } else {
            self.overallPstAtPCCLowerLabel.textColor = UIColor.errorRedColor()
        }
        
        if ElectricArcFurnaceData.sharedInstance.overallPstAtPCCHigherValid() {
            self.overallPstAtPCCHigherLabel.textColor = UIColor.validGreenColor()
        } else {
            self.overallPstAtPCCHigherLabel.textColor = UIColor.errorRedColor()
        }
    }
    
    // MARK: - Button Actions

    
    func missingInputsButtonPressed(_ sender: UIButton) {
        
        var errorsString = ""
        
        if ElectricArcFurnaceData.sharedInstance.missingInputs().count > 0 {
            errorsString += "Missing/Invalid Electric Arc Furnace Inputs\n\n"
            errorsString += ElectricArcFurnaceData.sharedInstance.missingInputsString(",\n")
            errorsString += "\n\n"
        }
        
        if FlickerLimits.sharedInstance.missingInputs().count > 0 {
            errorsString += "Missing/Invalid Flicker Limit Inputs\n\n"
            errorsString += FlickerLimits.sharedInstance.missingInputString(",\n")
        }
        
        assert(errorsString != "", "Should never have gotten here if there was no errors!")
        
        let alert = UIAlertController(title: "Missing Inputs", message: errorsString, preferredStyle: .alert)

        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        self.problemBaseViewController.present(alert, animated: true, completion: nil)
        
    
        
    }
    
    func outsideOfLimitsButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Outside of Limits", message: "One or more values are outside of the flicker limits", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        self.problemBaseViewController.present(alert, animated: true, completion: nil)
        
    }
    
    func withinLimitsButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Within Limits", message: "You are within the flicker limits!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        self.problemBaseViewController.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        HelpModalViewController.sharedInstance?.configureWebViewWithPDF(URL.init(fileURLWithPath: ElectricArcFurnaceData.HELP_PDF_URL), title: ElectricArcFurnaceData.HELP_TITLE)
        AppDelegate.rootViewController().toggleHelpModal()
    }
}

extension ElectricArcFurnaceResultsView : FlickerLimitProtocol {
    func flickerLimitsDidChange() {
        self.updateView()
    }
    
    func flickerLimitsDidReset() {
        self.updateView()
    }
}

extension ElectricArcFurnaceResultsView : ElectricArcFurnaceProtocol {
    func electricArcFurnaceDataDidChange() {
        self.updateView()
    }
    
    func electricArcFurnaceDataDidReset() {
        self.updateView()
    }
}
