//
//  FlickerLimitsViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/16/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class FlickerLimitsViewController: UIViewController {
    
    fileprivate enum SectionData : Int {
        case pccDetails = 0
        case allocatingFlickerEmissionLimit = 1
        
        static func count() -> Int {
            return SectionData.allocatingFlickerEmissionLimit.rawValue + 1
        }
    }
    
    fileprivate enum PCCDetailsRowData : Int {
        case upstreamSystemRatedVoltage = 0
        case pccRatedVoltage = 1
        case backgroundFlicker = 2
        
        static func count() -> Int {
            return PCCDetailsRowData.backgroundFlicker.rawValue + 1
        }
        
        func setNewLimitPropertyValue(_ value: String?) {
            
            let doubleValue = (value != nil) ? Double(value!) : nil
            
            if self == .upstreamSystemRatedVoltage {
                FlickerLimits.sharedInstance.upstreamSystemRatedVoltage = doubleValue
            } else if self == .pccRatedVoltage {
                FlickerLimits.sharedInstance.pccRatedVoltage = doubleValue
            } else if self == .backgroundFlicker {
                FlickerLimits.sharedInstance.backgroundFlicker = doubleValue
            } else {
                assert(false, "No known FlickerLimit property for \(self)")
            }
        }
    }
    
    fileprivate enum AllocatingFlickerEmissionLimitRowData : Int {
        case upstreamPlanningLevel = 0
        case upstreamSystemToPCCTransferCoefficient = 1
        case pccToUpstreamTransferCoefficient = 2
        case pccPlanningLevel = 3
        case summationLawExponent = 4
        case sizeOfPCCUnderLoad = 5
        case totalCapacityOfSystemAtPCCAndLCInMVA = 6
        case totalPowerOfLoadInLVSystemInMVA = 7
        
        static func count() -> Int {
            return AllocatingFlickerEmissionLimitRowData.totalPowerOfLoadInLVSystemInMVA.rawValue + 1
        }
        
        func setNewLimitPropertyValue(_ value: String?) {
            
            let doubleValue = (value != nil) ? Double(value!) : nil
            
            if self == .upstreamPlanningLevel {
                FlickerLimits.sharedInstance.upstreamPlanningLevel = doubleValue
            } else if self == .upstreamSystemToPCCTransferCoefficient {
                FlickerLimits.sharedInstance.upstreamSystemToPCCTransferCoefficient = doubleValue
            } else if self == .pccToUpstreamTransferCoefficient {
                FlickerLimits.sharedInstance.pccToUpstreamSystemTransferCoefficient = doubleValue
            } else if self == .pccPlanningLevel {
                FlickerLimits.sharedInstance.pccPlanningLevel = doubleValue
            } else if self == .summationLawExponent {
                FlickerLimits.sharedInstance.summationLawExponent = doubleValue
            } else if self == .sizeOfPCCUnderLoad {
                FlickerLimits.sharedInstance.sizeOfPCCUnderLoad = doubleValue
            } else if self == .totalCapacityOfSystemAtPCCAndLCInMVA {
                FlickerLimits.sharedInstance.totalCapacityOfSystemAtPCCAndLCInMVA = doubleValue
            } else if self == .totalPowerOfLoadInLVSystemInMVA {
                FlickerLimits.sharedInstance.totalPowerOfLoadInLVSystemInMVA = doubleValue
            } else {
                assert(false, "No known FlickerLimit property for \(self)")
            }
        }
    }
    
    fileprivate enum OutputData : Int {
        case maximumGlobalContributionAtPCC = 1
        case emissionLimit = 2
        
        func setNewLimitPropertyValue(_ value: String?) {
            
            let doubleValue = (value != nil) ? Double(value!) : nil
            
            if self == .maximumGlobalContributionAtPCC {
                FlickerLimits.sharedInstance.manualMaximumGlobalContributionApPCC = doubleValue
            } else if self == .emissionLimit {
                FlickerLimits.sharedInstance.manualEmissionLimit = doubleValue
            } else {
                assert(false, "No known FlickerLimit property for \(self)")
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!

//    @IBOutlet var segmentedControlContainer: UIView!
    @IBOutlet var maximumGlobalContributionContainer: UIView!
    @IBOutlet var emissionLimitContainer: UIView!
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var helpButton: UIButton!
	
	@IBOutlet var manualInputSwitch: UISwitch!
    
    fileprivate var segmentedControl : GMSWSegmentedControl!
    
    fileprivate var maximumGlobalContributionView : SingleInputView!
    fileprivate var emissionLimitView : SingleInputView!
    
    fileprivate var currentFirstResponder : UITextField?
    fileprivate var indexPathToScrollToOnSelection : IndexPath?
    fileprivate var indexPathOfCellToBecomeNextFirstResponder : IndexPath?
    
    // MARK: - View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setupSegmentedControl()
        FlickerLimits.sharedInstance.manualMode = false
        self.setupOutputContainers()
        self.configureOutputViews()
        
        FlickerLimits.sharedInstance.delegates.append(self)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if UIDevice.current.userInterfaceIdiom != .phone {
			AppDelegate.rootViewController().title = "Flicker Limits"
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Subview Configuration
    // MARK: Segmented Control
//    func setupSegmentedControl() {
//        let selectedIndex = FlickerLimits.sharedInstance.manualMode == false ? 0 : 1
//        let theme = GMSWSegmentedControlTheme(highLightColor: UIColor.limitsYellowColor(), backgroundColor: UIColor.lightNavyBlueColor(), seperatorColor: UIColor.darkNavyBlueColor(), textColor: UIColor.white, textFont: UIFont(name: "HelveticaNeue-Thin", size: 20)!)
//        self.segmentedControl = GMSWSegmentedControl(frame: CGRect.zero, items: ["Calculated\nLimits", "Manual\nLimits"], selectedIndex: selectedIndex, theme: theme)
//        self.segmentedControl.delegate = self
//        self.segmentedControlContainer.addSubview(self.segmentedControl)
//        self.segmentedControl.applyPaddingToSuperViewConstraints(self.segmentedControlContainer, padding: 0)
//    }
    
    // MARK: Output Views
    func configureOutputViews() {
        
        if FlickerLimits.sharedInstance.manualMode == true {
            manualInputSwitch.setOn(true, animated: true)
        }else {
            manualInputSwitch.setOn(false, animated: true)
        }
        
        var maxGlobalContributionValid = true
        if FlickerLimits.sharedInstance.manualMode == true && FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC == nil {
            maxGlobalContributionValid = false
        }
        
        self.maximumGlobalContributionView.configureView("Max Global Cont. at PCC", value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC), indexPath: nil, valid: maxGlobalContributionValid, inputEnabled: FlickerLimits.sharedInstance.manualMode)
        self.maximumGlobalContributionView.inputTextField.returnKeyType = .next
        self.maximumGlobalContributionView.inputTextField.delegate = self
        self.maximumGlobalContributionView.inputTextField.tag = 1
        
        var emissionLimitValid = true
        if FlickerLimits.sharedInstance.manualMode == true && FlickerLimits.sharedInstance.emissionLimit == nil {
            emissionLimitValid = false
        }
        
        self.emissionLimitView.configureView("Emission Limit", value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.emissionLimit), indexPath: nil, valid: emissionLimitValid, inputEnabled: FlickerLimits.sharedInstance.manualMode)
        self.emissionLimitView.inputTextField.delegate = self
        self.emissionLimitView.inputTextField.returnKeyType = .done
        self.emissionLimitView.inputTextField.tag = 2
    }
    
    func setupOutputContainers() {
        self.maximumGlobalContributionView = SingleInputView.viewByTypeFromNibNamed(INPUT_VIEWS)
        self.maximumGlobalContributionView.titleLabel.textColor = UIColor.limitsYellowColor()
        self.maximumGlobalContributionContainer.addSubview(self.maximumGlobalContributionView)
        self.maximumGlobalContributionView.applyPaddingToSuperViewConstraints(self.maximumGlobalContributionContainer, padding: 0)

        self.emissionLimitView = SingleInputView.viewByTypeFromNibNamed(INPUT_VIEWS)
        self.emissionLimitView.titleLabel.textColor = UIColor.limitsYellowColor()
        self.emissionLimitContainer.addSubview(self.emissionLimitView)
        self.emissionLimitView.applyPaddingToSuperViewConstraints(self.emissionLimitContainer, padding: 0)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Keyboard Callbacks
    func keyboardWillShow(_ notification: Notification){
        let info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.view.layoutIfNeeded()
        self.keyboardHeightConstraint.constant = keyboardFrame.size.height  - 49 // subtract tab bar height
        if let indexPath = self.indexPathToScrollToOnSelection {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }
    
    func keyboardWillHide() {
        self.keyboardHeightConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }
    
    // MARK: - Help
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            AppDelegate.rootViewController().hideLimitsModal()
//        }
        
        HelpModalViewController.sharedInstance?.configureWebViewWithPDF(URL.init(fileURLWithPath: FlickerLimits.HELP_PDF_URL), title: FlickerLimits.HELP_TITLE)
        AppDelegate.rootViewController().toggleHelpModal()
	}
//MARK: - Manual Input Switch

	@IBAction func manualInputValueDidChange(_ sender: UISwitch) {

		if sender.isOn {
			FlickerLimits.sharedInstance.manualMode = true
		} else {
			FlickerLimits.sharedInstance.manualMode = false
		}

        self.configureOutputViews()
        
//        self.currentFirstResponder?.resignFirstResponder()
	}
	
}


//MARK: - UITableView Delegate / Data Source
extension FlickerLimitsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 8
        }
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 62
        } else {
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = self.indexPathOfCellToBecomeNextFirstResponder {
            self.makeFirstResponder(indexPath)
        }
    }
}

extension FlickerLimitsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : SingleInputTableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: SingleInputTableViewCell.reuseID()) as? SingleInputTableViewCell
        if cell == nil {
            cell = SingleInputTableViewCell()
        }
        
        if (indexPath as NSIndexPath).section == SectionData.pccDetails.rawValue {
            if (indexPath as NSIndexPath).row == PCCDetailsRowData.upstreamSystemRatedVoltage.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.upstreamSystemRatedVoltage == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.UPSTREAM_SYSTEM_RATED_VOLTAGE, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.upstreamSystemRatedVoltage), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == PCCDetailsRowData.pccRatedVoltage.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.pccRatedVoltage == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.PCC_RATED_VOLTAGE, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.pccRatedVoltage), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == PCCDetailsRowData.backgroundFlicker.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.backgroundFlicker == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.BACKGROUND_FLICKER, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.backgroundFlicker), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else {
                assert(false, "no cell configration for indexPath: \(indexPath)")
            }
        } else {
            if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.upstreamPlanningLevel.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.upstreamPlanningLevel == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.UPSTREAM_PLANNING_LEVEL, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.upstreamPlanningLevel), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.upstreamSystemToPCCTransferCoefficient.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.upstreamSystemToPCCTransferCoefficient == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.upstreamSystemToPCCTransferCoefficient), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.pccToUpstreamTransferCoefficient.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.pccToUpstreamSystemTransferCoefficient == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.pccToUpstreamSystemTransferCoefficient), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.pccPlanningLevel.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.pccPlanningLevel == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.PCC_PLANNING_LEVEL, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.pccPlanningLevel), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.summationLawExponent.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.summationLawExponent == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.SUMMATION_LAW_EXPONENT, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.summationLawExponent), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.sizeOfPCCUnderLoad.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.sizeOfPCCUnderLoad == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.SIZE_OF_PCC_UNDER_LOAD, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.sizeOfPCCUnderLoad), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.totalCapacityOfSystemAtPCCAndLCInMVA.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.totalCapacityOfSystemAtPCCAndLCInMVA == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.TOTAL_CAPACITY_OF_SYSTEM_AT_PCC_AND_LV_IN_MVA, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.totalCapacityOfSystemAtPCCAndLCInMVA), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if (indexPath as NSIndexPath).row == AllocatingFlickerEmissionLimitRowData.totalPowerOfLoadInLVSystemInMVA.rawValue {
                
                var valid = true
                if FlickerLimits.sharedInstance.totalPowerOfLoadInLVSystemInMVA == nil {
                    valid = false
                }
                
                cell.configureCell(FlickerLimits.TOTAL_POWER_OF_LOAD_IN_LV_SYSTEM_IN_MVA, value: FlickerLimits.formattedDoubleValue(FlickerLimits.sharedInstance.totalPowerOfLoadInLVSystemInMVA), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
                cell.singleInputView?.inputTextField.returnKeyType = .done
            }  else {
                assert(false, "no cell configration for indexPath: \(indexPath)")
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: HeaderView!
        header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_VIEW) as? HeaderView
        if header == nil {
            header = HeaderView.viewByTypeFromNibNamed(TABLE_HEADER_VIEWS)
        }
        
        if section == SectionData.pccDetails.rawValue {
            header.configure("PCC Details")
        } else if section == SectionData.allocatingFlickerEmissionLimit.rawValue {
            header.configure("Allocating Flicker Emission Limits")
        } else {
            assert(false, "no header configuration for section: \(section)")
        }
        
        return header
    }
}

//MARK: - UITextField Delegate + Methods
extension FlickerLimitsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.indexPathToScrollToOnSelection = textField.indexPath as IndexPath?
        self.currentFirstResponder = textField
        
        if let rootiPhoneViewController = AppDelegate.rootViewController() as? RootiPhoneViewController {
            rootiPhoneViewController.showDoneButton()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.indexPathToScrollToOnSelection = nil
        self.currentFirstResponder = nil
        
        if let indexPath = textField.indexPath {
            if (indexPath as NSIndexPath).section == SectionData.pccDetails.rawValue {
                let rowData = PCCDetailsRowData.init(rawValue: (indexPath as NSIndexPath).row)
                rowData?.setNewLimitPropertyValue(textField.text)
            } else if (indexPath as NSIndexPath).section == SectionData.allocatingFlickerEmissionLimit.rawValue {
                let rowData = AllocatingFlickerEmissionLimitRowData.init(rawValue: (indexPath as NSIndexPath).row)
                rowData?.setNewLimitPropertyValue(textField.text)
            } else {
                assert(false, "no section for text field did end editing! \(indexPath)")
            }
            
            
            var indexPathsToReload = [indexPath]
            if (indexPath as NSIndexPath).section == SectionData.pccDetails.rawValue &&
                (indexPath as NSIndexPath).row == PCCDetailsRowData.upstreamSystemRatedVoltage.rawValue {
        
                indexPathsToReload.append(IndexPath(row: AllocatingFlickerEmissionLimitRowData.upstreamPlanningLevel.rawValue, section: SectionData.allocatingFlickerEmissionLimit.rawValue))
                
            } else if (indexPath as NSIndexPath).section == SectionData.pccDetails.rawValue &&
                (indexPath as NSIndexPath).row == PCCDetailsRowData.pccRatedVoltage.rawValue {
                
                indexPathsToReload.append(IndexPath(row: AllocatingFlickerEmissionLimitRowData.pccPlanningLevel.rawValue, section: SectionData.allocatingFlickerEmissionLimit.rawValue))
                
            }
            
            self.tableView.reloadRows(at: indexPathsToReload as [IndexPath], with: .automatic)
        } else {
//            if self.segmentedControl.getSelectedIndex() == 1 {
            if FlickerLimits.sharedInstance.manualMode {
                let outputData = OutputData.init(rawValue: textField.tag)
                outputData?.setNewLimitPropertyValue(textField.text)
            }
            self.configureOutputViews()
        }
        
        
        if let rootiPhoneViewController = AppDelegate.rootViewController() as? RootiPhoneViewController {
            rootiPhoneViewController.hideDoneButton()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let indexPath = textField.indexPath {
            
            if indexPath as IndexPath == IndexPath(row: AllocatingFlickerEmissionLimitRowData.count() - 1, section: SectionData.allocatingFlickerEmissionLimit.rawValue) {
                textField.resignFirstResponder()
            } else {
                if let nextIndexPath = FlickerLimitsViewController.nextIndexPath(indexPath as IndexPath) {
                    self.indexPathOfCellToBecomeNextFirstResponder = nextIndexPath
                    if let _ = self.tableView.cellForRow(at: nextIndexPath) {
                        self.makeFirstResponder(nextIndexPath)
                    } else {
                        self.tableView.scrollToRow(at: nextIndexPath, at: .top, animated: true)
                    }
                }
            }
        } else {
            if textField == self.maximumGlobalContributionView.inputTextField {
                self.emissionLimitView.inputTextField.becomeFirstResponder()
            } else if textField == self.emissionLimitView.inputTextField {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    fileprivate static func nextIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        
        var nextIndexPath : IndexPath?
    
        if (indexPath as NSIndexPath).section == SectionData.pccDetails.rawValue {
            if (indexPath as NSIndexPath).row == PCCDetailsRowData.count() - 1 {
                nextIndexPath = IndexPath(row: 0, section: SectionData.pccDetails.rawValue + 1)
            } else {
                nextIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: SectionData.pccDetails.rawValue)
            }
        } else if (indexPath as NSIndexPath).section == SectionData.allocatingFlickerEmissionLimit.rawValue {
            if (indexPath as NSIndexPath).row != AllocatingFlickerEmissionLimitRowData.count() - 1 {
                nextIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: SectionData.allocatingFlickerEmissionLimit.rawValue)
            }
        } else {
            assert(false, "no textfield should return handler for indexpath: \(indexPath)")
        }
        
        return nextIndexPath
    }
    
    fileprivate func makeFirstResponder(_ indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? SingleInputTableViewCell {
            cell.makeInputFieldFirstResponder()
        }
        self.indexPathOfCellToBecomeNextFirstResponder = nil
    }
}

//MARK: - FlickerLimits Delegate
extension FlickerLimitsViewController : FlickerLimitProtocol {
    func flickerLimitsDidChange() {
        self.configureOutputViews()
    }
    
    func flickerLimitsDidReset() {
        self.tableView.reloadData()
        self.configureOutputViews()
    }
}

//MARK: - GMSWSegmentedControl Delegate
extension FlickerLimitsViewController : GMSWSegmentedControlDelegate {
	
    func valueDidChange(_ index: Int, item: String) {
        if index == 0 {
            FlickerLimits.sharedInstance.manualMode = false
        } else {
            FlickerLimits.sharedInstance.manualMode = true
        }
        
        self.configureOutputViews()
        
        self.currentFirstResponder?.resignFirstResponder()
    }
}
