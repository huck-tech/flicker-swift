//
//  RepetitiveLoadResultsView.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class RepetitiveLoadResultsView: UIView {
    
    fileprivate weak var problemBaseViewController : ProblemBaseViewController!

    @IBOutlet var errorsButton: UIButton!
    
    @IBOutlet var pstFlickerDueToLoadAtPCCLabel: UILabel!
    @IBOutlet var pstOverallFlickerAtPCCLabel: UILabel!
    @IBOutlet var pstOverallFlickerAtUSBusLabel: UILabel!
    
    @IBOutlet var maxCurrentFlickerDueToLoadAtPCCLabel: UILabel!
    @IBOutlet var maxCurrentOverallFlickerAtPCCLabel: UILabel!
    
    func configureView(_ problemBaseViewController: ProblemBaseViewController) {
        
        self.problemBaseViewController = problemBaseViewController
        
        self.updateView()
        
        RepetitiveLoadData.sharedInstance.delegates.append(self)
    }
    
    fileprivate func updateView() {
        self.updateResultLabelValues()
        self.updateResultLabelColors()
        
        self.updateErrorsButton()
    }
    
    fileprivate func updateErrorsButton() {
        
        let repetitiveLoadMissingInputs = RepetitiveLoadData.sharedInstance.missingInputs()
        let repetitiveLoadInvalidInputs = RepetitiveLoadData.sharedInstance.invalidInputs()
        let flickerLimitsMissingInputs = FlickerLimits.sharedInstance.missingInputs()
        
        self.errorsButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if repetitiveLoadMissingInputs.count > 0 || repetitiveLoadInvalidInputs.count > 0 || flickerLimitsMissingInputs.count > 0  {
            self.errorsButton.setTitle("\(repetitiveLoadMissingInputs.count + repetitiveLoadInvalidInputs.count + flickerLimitsMissingInputs.count)", for: UIControlState())
            self.errorsButton.setTitle("\(repetitiveLoadMissingInputs.count + repetitiveLoadInvalidInputs.count + flickerLimitsMissingInputs.count)", for: .highlighted)
            self.errorsButton.setBackgroundImage(UIImage(named: "InvalidInputsButton"), for: UIControlState())
            self.errorsButton.setBackgroundImage(UIImage(named: "InvalidInputsButton-Selected"), for: .highlighted)
            self.errorsButton.addTarget(self, action: #selector(missingAndInvalidInputsButtonPressed), for: .touchUpInside)
        } else if RepetitiveLoadData.sharedInstance.withinLimits() == false {
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
        
        self.pstFlickerDueToLoadAtPCCLabel.text = RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.flickerDueToLoadAtPCCPst, emptyValue: resultsViewEmptyValue)
        
        self.pstOverallFlickerAtPCCLabel.text = RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.overallFlickerAtPCCPst, emptyValue: resultsViewEmptyValue)
        
        self.pstOverallFlickerAtUSBusLabel.text = RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.overallFlickerAtUSBusPst, emptyValue: resultsViewEmptyValue)
        
        self.maxCurrentFlickerDueToLoadAtPCCLabel.text = RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.flickerDueToLoadAtPCCMaxCurrent, emptyValue: resultsViewEmptyValue)
        
        self.maxCurrentOverallFlickerAtPCCLabel.text = RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.overallFlickerAtPCCMaxCurrent, emptyValue: resultsViewEmptyValue)
    }
    
    fileprivate func updateResultLabelColors() {
        
        if RepetitiveLoadData.sharedInstance.flickerDueToLoadAtPCCPstValid() {
            self.pstFlickerDueToLoadAtPCCLabel.textColor = UIColor.validGreenColor()
        } else {
            self.pstFlickerDueToLoadAtPCCLabel.textColor = UIColor.errorRedColor()
        }
        
        if RepetitiveLoadData.sharedInstance.overallFlickerAtPCCPstValid() {
            self.pstOverallFlickerAtPCCLabel.textColor = UIColor.validGreenColor()
        } else {
            self.pstOverallFlickerAtPCCLabel.textColor = UIColor.errorRedColor()
        }
    }
    
    // MARK: - Button Actions
    func missingAndInvalidInputsButtonPressed(_ sender: UIButton) {
        
        var errorsString = ""
        
        if RepetitiveLoadData.sharedInstance.missingInputs().count > 0 {
            errorsString += "Missing/Invalid Repetitive Load Inputs\n\n"
            errorsString += RepetitiveLoadData.sharedInstance.missingInputsString(",\n")
            errorsString += "\n\n"
        }
        
        if RepetitiveLoadData.sharedInstance.invalidInputs().contains(RepetitiveLoadData.CHANGE_RATE) ||
            RepetitiveLoadData.sharedInstance.invalidInputs().contains(RepetitiveLoadData.CHANGE_UNIT) {
            
            let error = RepetitiveLoadData.changeRateIsValid(RepetitiveLoadData.sharedInstance.shapeType!,
                                                 changeRate: RepetitiveLoadData.sharedInstance.changeRate!,
                                                 changeUnit: RepetitiveLoadData.sharedInstance.changeUnit!).errorMessage!
            
            errorsString += error
        }
        
        if RepetitiveLoadData.sharedInstance.invalidInputs().contains(RepetitiveLoadData.DURATION_OF_VOLTAGE_CHANGE) {
            
            let error = RepetitiveLoadData.durationOfVoltageChangeIsValid(RepetitiveLoadData.sharedInstance.shapeType!,
                                                                          durationOfVoltageChange: RepetitiveLoadData.sharedInstance.durationOfVoltageChange!).errorMessage!
            
            errorsString += error
            
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
        HelpModalViewController.sharedInstance?.configureWebViewWithPDF(URL.init(fileURLWithPath: RepetitiveLoadData.HELP_PDF_URL), title: RepetitiveLoadData.HELP_TITLE)
        AppDelegate.rootViewController().toggleHelpModal()
    }
}

extension RepetitiveLoadResultsView : RepetitiveLoadProtocol {
    func repetitiveLoadDataDidChange() {
        self.updateView()
    }
    
    func repetitiveLoadDataDidReset() {
        self.updateView()
    }
    
    func shapeTypeDidChange() { }
}
