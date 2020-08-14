//
//  ElectricArcFurnaceInputView.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class ElectricArcFurnaceInputView: UIView {
    
    @IBOutlet weak var container: StyledContainer!
    @IBOutlet weak var containerLeadingPadding: NSLayoutConstraint!
    @IBOutlet weak var containerBottomPadding: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingPadding: NSLayoutConstraint!
    @IBOutlet weak var containerTopPadding: NSLayoutConstraint!

    
    fileprivate enum RowData : Int {
        case threePhaseShortCircuitStrengthInMVAAtPCC = 0
        case furnaceSize = 1
        case highReactanceDesign = 2
        case highReactanceDesignCorrectionFactor = 3
        case furnaceType = 4
        case furnaceTypeCorrectionFactor = 5
        case compensation = 6
        case compensationCorrectionFactor = 7
        case lampBaseVoltage = 8
        
        static func count() -> Int {
            return RowData.lampBaseVoltage.rawValue + 1
        }
        
        func name() -> String {
            if self == .threePhaseShortCircuitStrengthInMVAAtPCC {
                return ElectricArcFurnaceData.THREE_PHASE_SHORT_CIRCUIT_STRENGTH_AT_PCC
            } else if self == .furnaceSize {
                return ElectricArcFurnaceData.FURNACE_SIZE
            } else if self == .highReactanceDesign {
                return ElectricArcFurnaceData.HIGH_REACTANCE_DESIGN
            } else if self == .highReactanceDesignCorrectionFactor {
                return ElectricArcFurnaceData.HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR
            } else if self == .furnaceType {
                return ElectricArcFurnaceData.FURNACE_TYPE
            } else if self == .furnaceTypeCorrectionFactor {
                return ElectricArcFurnaceData.FURNACE_TYPE_CORRECTION_FACTOR
            } else if self == .compensation {
                return ElectricArcFurnaceData.COMPENSATION
            } else if self == .compensationCorrectionFactor {
                return ElectricArcFurnaceData.COMPENSATION_CORRECTION_FACTOR
            } else if self == .lampBaseVoltage {
                return ElectricArcFurnaceData.LAMP_BASE_VOLTAGE
            } else {
                assert(false, "no RowData name found for \(self)")
                return "INVALID"
            }
        }
        
        func setNewElectricArcFurnacePropertyValue(_ value: String?) {
            let doubleValue = (value != nil) ? Double(value!) : nil
            
            if self == .threePhaseShortCircuitStrengthInMVAAtPCC {
                ElectricArcFurnaceData.sharedInstance.threePhaseShortCircuitStrenghAtPCC = doubleValue
            } else if self == .furnaceSize {
                ElectricArcFurnaceData.sharedInstance.furnaceSize = doubleValue
            } else if self == .highReactanceDesignCorrectionFactor {
                ElectricArcFurnaceData.sharedInstance.highReactanceDesignCorrectionFactor = doubleValue
            } else if self == .furnaceTypeCorrectionFactor {
                ElectricArcFurnaceData.sharedInstance.furnaceTypeCorrectionFactor = doubleValue
            } else if self == .compensationCorrectionFactor {
                ElectricArcFurnaceData.sharedInstance.compensationCorrectionFactor = doubleValue
            } else {
                assert(false, "No Known Settable ElectricArcFurnaceData property for \(self)")
            }
        }
        
        func setNewElectricArcFurnacePropertyValue(_ value: Double?) {
            
            if self == .highReactanceDesignCorrectionFactor {
                ElectricArcFurnaceData.sharedInstance.highReactanceDesignCorrectionFactor = value
            } else if self == .furnaceTypeCorrectionFactor {
                ElectricArcFurnaceData.sharedInstance.furnaceTypeCorrectionFactor = value
            } else if self == .compensationCorrectionFactor {
                ElectricArcFurnaceData.sharedInstance.compensationCorrectionFactor = value
            } else {
                assert(false, "No Known Settable ElectricArcFurnaceData property for \(self)")
            }
        }
        
        func arrayStringValues() -> [String]? {
            if self == .highReactanceDesign {
                return ElectricArcFurnaceData.HighReactanceDesign.arrayStringValues()
            } else if self == .furnaceType {
                return ElectricArcFurnaceData.FurnaceType.arrayStringValues()
            } else if self == .compensation {
                return ElectricArcFurnaceData.Compensation.arrayStringValues()
            } else if self == .lampBaseVoltage {
                return ElectricArcFurnaceData.LampBaseVoltage.arrayStringValues()
            } else {
                assert(false, "should out call this on HighReactanceDesign, FurnaceType, Compensation and LampBaseVoltage. You called it on \(self)")
                return nil
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var currentFirstResponder : UITextField?
    fileprivate var indexPathToScrollToOnSelection : IndexPath?
    fileprivate var indexPathOfCellToBecomeNextFirstResponder : IndexPath?
    
    fileprivate var indexPathForMultipleSelectionPopover : IndexPath?
    
    fileprivate weak var problemBaseViewController : ProblemBaseViewController!
    fileprivate var inputPopoverController : UIPopoverPresentationController?
    
    
    // MARK: - View Configuration
    func configureView(_ problemBaseViewController: ProblemBaseViewController) {
        self.problemBaseViewController = problemBaseViewController
        
        ElectricArcFurnaceData.sharedInstance.delegates.append(self)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            self.container.shadowColor = UIColor.clear
            self.container.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.container.shadowRadius = 0.0
            self.container.shadowOpacity = 0.0
            
            self.container.borderColor = UIColor.clear
            self.container.borderWidth = 0.0
            
            self.containerTopPadding.constant = 0
            self.containerLeadingPadding.constant = 0
            self.containerTrailingPadding.constant = 0
            self.containerBottomPadding.constant = 0
            self.layoutIfNeeded()
            
        }
    }
    
    // MARK: - Button Callbacks
    func sliderValueDidChange(_ slider: UISlider) {
        
        let roundedValue = Double(slider.value).roundToPlaces(2)
        
        self.updateSliderInputTextViewOnly(slider.indexPath!, value: roundedValue)
    }
    
    func sliderDidFinishChangingValue(_ slider: UISlider) {
        
        let roundedValue = Double(slider.value).roundToPlaces(2)
        
        let rowData = RowData(rawValue: (slider.indexPath! as NSIndexPath).row)
        assert(rowData != nil, "Could not find RowData for indexpath: \(String(describing: slider.indexPath))")
        rowData?.setNewElectricArcFurnacePropertyValue(roundedValue)
    }
    
    // MARK: - Multiple Selection
    func multipleSelectionPopoverButtonPressed(_ sender: UIButton) {
        let rowData = RowData(rawValue: (sender.indexPath! as NSIndexPath).row)!
        self.showMultipleSelectionPopover(rowData, sourceView: sender)
    }
    
    fileprivate func showMultipleSelectionPopover(_ rowData: RowData, sourceView: UIView) {
        if self.inputPopoverController != nil {
//      if let popoverController = self.inputPopoverController {
// TODO: what goes here now?
//            popoverController.dismiss(animated: false)
        }
        
        self.indexPathForMultipleSelectionPopover = IndexPath(row: rowData.rawValue, section: 0)
        

        var storyboard: String!
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = "Main-iPhone"
            break
            
        default:
            storyboard = "Main"
            break
        
        }

        let selectionTableViewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: SelectionTableViewController.STORYBOARD_ID) as! SelectionTableViewController
        
        selectionTableViewController.modalPresentationStyle = .popover
        selectionTableViewController.preferredContentSize = CGSize(width: 300, height: 400)
        selectionTableViewController.popoverPresentationController?.sourceView = sourceView.superview
        selectionTableViewController.popoverPresentationController?.delegate = self
        
        selectionTableViewController.view.backgroundColor = UIColor.lightNavyBlueColor()
        selectionTableViewController.popoverPresentationController?.backgroundColor = UIColor.lightNavyBlueColor()
        
        let rect = CGRect(x: 0, y: sourceView.superview!.frame.size.height / 2.0, width: 0, height: 0)
        selectionTableViewController.popoverPresentationController?.sourceRect = rect
        
        selectionTableViewController.popoverPresentationController?.permittedArrowDirections = [.right]
        self.problemBaseViewController.present(selectionTableViewController, animated: true) {
            selectionTableViewController.delegate = self
            
            var index : Int?
            if rowData == .highReactanceDesign {
                index = ElectricArcFurnaceData.sharedInstance.highReactanceDesign?.index()
            } else if rowData == .furnaceType {
                index = ElectricArcFurnaceData.sharedInstance.furnaceType?.index()
            } else if rowData == .compensation {
                index = ElectricArcFurnaceData.sharedInstance.compensation?.index()
            } else if rowData == .lampBaseVoltage {
                index = ElectricArcFurnaceData.sharedInstance.lampBaseVoltage?.index()
            } else {
                assert(false, "No index for multiple selection popover for rowData \(rowData)")
            }
            
            selectionTableViewController.configure(rowData.arrayStringValues()!, selectedIndex: index, title: rowData.name())
        }
    }
    
    // MARK: - Utility Methods
    fileprivate static func cellIsNotSelectable(_ rowData: RowData) -> Bool {
        
        if rowData == .threePhaseShortCircuitStrengthInMVAAtPCC ||
            rowData == .furnaceSize {
            return false
        } else {
            return true
        }
    }
    
    fileprivate static func cellShouldBeHidden(_ rowData: RowData) -> Bool {
        
        if rowData == .highReactanceDesignCorrectionFactor && ElectricArcFurnaceData.sharedInstance.highReactanceDesign == ElectricArcFurnaceData.HighReactanceDesign.No {
            return true
        } else if rowData == .furnaceTypeCorrectionFactor && ElectricArcFurnaceData.sharedInstance.furnaceType == ElectricArcFurnaceData.FurnaceType.AC {
            return true
        } else if rowData == .compensationCorrectionFactor && ElectricArcFurnaceData.sharedInstance.compensation == ElectricArcFurnaceData.Compensation.None {
            return true
        }
        
        return false
    }
    
    fileprivate func updateSliderInputTextViewOnly(_ indexPath: IndexPath, value: Double) {
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? SliderInputTableViewCell {
            cell.updateInputTextViewOnly(value)
        } else {
            assert(false, "expected SliderInputTableViewCell!")
        }
    }
}



// MARK: - UITableView Delegate/DataSource
extension ElectricArcFurnaceInputView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowData.count()
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowData = RowData.init(rawValue: (indexPath as NSIndexPath).row)
        
        if ElectricArcFurnaceInputView.cellShouldBeHidden(rowData!) {
            return 0
        } else {
            return 60
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = self.indexPathOfCellToBecomeNextFirstResponder {
            self.makeFirstResponder(indexPath)
        }
    }
}

extension ElectricArcFurnaceInputView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = RowData.init(rawValue: (indexPath as NSIndexPath).row)
        
        if rowData == .highReactanceDesignCorrectionFactor ||
            rowData == .furnaceTypeCorrectionFactor ||
            rowData == .compensationCorrectionFactor {
            
            var cell : SliderInputTableViewCell!
            
            cell = tableView.dequeueReusableCell(withIdentifier: SliderInputTableViewCell.reuseID()) as? SliderInputTableViewCell
            if cell == nil {
                cell = SliderInputTableViewCell()
            }
            
            if rowData == RowData.highReactanceDesignCorrectionFactor {
                
                var range: (lower: Double, upper: Double)!
                if let highReactanceDesign = ElectricArcFurnaceData.sharedInstance.highReactanceDesign {
                    range = highReactanceDesign.correctionFactor()
                } else {
                    range = (1.0, 1.0)
                }
                
                var value: Double!
                if let highReactanceDesignCorrectionFactor = ElectricArcFurnaceData.sharedInstance.highReactanceDesignCorrectionFactor {
                    value = highReactanceDesignCorrectionFactor
                } else {
                    value = 1.0
                }
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.highReactanceDesignCorrectionFactor == nil {
                    valid = false
                }
                
                cell.configureCell(range, value: value, indexPath: indexPath, valid: valid)
                cell.sliderInputView?.slider.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.sliderInputView?.slider.addTarget(self, action: #selector(sliderValueDidChange), for: UIControlEvents.valueChanged)
                cell.sliderInputView?.slider.addTarget(self, action: #selector(sliderDidFinishChangingValue), for: [UIControlEvents.touchUpInside, UIControlEvents.touchUpOutside])
                
            } else if rowData == RowData.furnaceTypeCorrectionFactor {
                
                var range: (lower: Double, upper: Double)!
                if let furnaceType = ElectricArcFurnaceData.sharedInstance.furnaceType {
                    range = furnaceType.correctionFactor()
                } else {
                    range = (1.0, 1.0)
                }
                
                var value: Double!
                if let furnaceTypeCorrectionFactor = ElectricArcFurnaceData.sharedInstance.furnaceTypeCorrectionFactor {
                    value = furnaceTypeCorrectionFactor
                } else {
                    value = 1.0
                }
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.furnaceTypeCorrectionFactor == nil {
                    valid = false
                }
                
                cell.configureCell(range, value: value, indexPath: indexPath, valid: valid)
                cell.sliderInputView?.slider.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.sliderInputView?.slider.addTarget(self, action: #selector(sliderValueDidChange), for: UIControlEvents.valueChanged)
                cell.sliderInputView?.slider.addTarget(self, action: #selector(sliderDidFinishChangingValue), for: [UIControlEvents.touchUpInside, UIControlEvents.touchUpOutside])
                
            } else if rowData == RowData.compensationCorrectionFactor {
                
                var range: (lower: Double, upper: Double)!
                if let compensation = ElectricArcFurnaceData.sharedInstance.compensation {
                    range = compensation.correctionFactor()
                } else {
                    range = (1.0, 1.0)
                }
                
                var value: Double!
                if let compensationCorrectionFactor = ElectricArcFurnaceData.sharedInstance.compensationCorrectionFactor {
                    value = compensationCorrectionFactor
                } else {
                    value = 1.0
                }
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.compensationCorrectionFactor == nil {
                    valid = false
                }
                
                cell.configureCell(range, value: value, indexPath: indexPath, valid: valid)
                cell.sliderInputView?.slider.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.sliderInputView?.slider.addTarget(self, action: #selector(sliderValueDidChange), for: UIControlEvents.valueChanged)
                cell.sliderInputView?.slider.addTarget(self, action: #selector(sliderDidFinishChangingValue), for: [UIControlEvents.touchUpInside, UIControlEvents.touchUpOutside])
                
            } else {
                assert(false, "Unknown RowData for cellForRowAtIndexPath: \(indexPath) - \(String(describing: rowData))")
            }
            
            let cellHidden = ElectricArcFurnaceInputView.cellShouldBeHidden(rowData!)
            cell.isHidden = cellHidden
            
            return cell
            
        } else if rowData == RowData.threePhaseShortCircuitStrengthInMVAAtPCC ||
            rowData == RowData.furnaceSize {
            
            var cell : SingleInputTableViewCell!
            
            cell = tableView.dequeueReusableCell(withIdentifier: SingleInputTableViewCell.reuseID()) as? SingleInputTableViewCell
            if cell == nil {
                cell = SingleInputTableViewCell()
            }
            
            if rowData == RowData.threePhaseShortCircuitStrengthInMVAAtPCC {
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.threePhaseShortCircuitStrenghAtPCC == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(),
                                   value: ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.threePhaseShortCircuitStrenghAtPCC),
                                   indexPath: indexPath,
                                   valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if rowData == RowData.furnaceSize {
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.furnaceSize == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(),
                                   value: ElectricArcFurnaceData.formattedDoubleValue(ElectricArcFurnaceData.sharedInstance.furnaceSize),
                                   indexPath: indexPath,
                                   valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
                cell.singleInputView?.inputTextField.returnKeyType = .done
            } else {
                assert(false, "Unknown RowData for cellForRowAtIndexPath: \(indexPath) - \(String(describing: rowData))")
            }
            
            return cell
            
        } else if rowData == RowData.highReactanceDesign ||
            rowData == RowData.furnaceType ||
            rowData == RowData.compensation ||
            rowData == RowData.lampBaseVoltage {
            
            var cell : MultipleSelectionTableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: MultipleSelectionTableViewCell.reuseID()) as? MultipleSelectionTableViewCell
            if cell == nil {
                cell = MultipleSelectionTableViewCell()
            }
            
            if rowData == RowData.highReactanceDesign {
                
                let showSeperatorView = (ElectricArcFurnaceData.sharedInstance.highReactanceDesign != nil) ? ElectricArcFurnaceData.sharedInstance.highReactanceDesign! == .No : true
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.highReactanceDesign == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(),
                                   values: ElectricArcFurnaceData.HighReactanceDesign.arrayStringValues(),
                                   selectedIndex: ElectricArcFurnaceData.sharedInstance.highReactanceDesign?.index(),
                                   indexPath: indexPath,
                                   valid: valid,
                                   selectionEnabled: true,
                                   showSeperatorView: showSeperatorView)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
//                cell.multipleSelectionView!.selectionButton.addTarget(self, action: nil, for: .touchUpInside)

            } else if rowData == RowData.furnaceType {
                
                let showSeperatorView = (ElectricArcFurnaceData.sharedInstance.furnaceType != nil) ? ElectricArcFurnaceData.sharedInstance.furnaceType! == .AC : true
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.furnaceType == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(),
                                   values: ElectricArcFurnaceData.FurnaceType.arrayStringValues(),
                                   selectedIndex: ElectricArcFurnaceData.sharedInstance.furnaceType?.index(),
                                   indexPath: indexPath,
                                   valid: valid,
                                   selectionEnabled: true,
                                   showSeperatorView: showSeperatorView)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
            } else if rowData == RowData.compensation {
                
                let showSeperatorView = (ElectricArcFurnaceData.sharedInstance.compensation != nil) ? ElectricArcFurnaceData.sharedInstance.compensation! == .None : true
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.compensation == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(),
                                   values: ElectricArcFurnaceData.Compensation.arrayStringValues(),
                                   selectedIndex: ElectricArcFurnaceData.sharedInstance.compensation?.index(),
                                   indexPath: indexPath,
                                   valid: valid,
                                   selectionEnabled: true,
                                   showSeperatorView: showSeperatorView)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
            } else if rowData == RowData.lampBaseVoltage {
                
                
                var valid = true
                if ElectricArcFurnaceData.sharedInstance.lampBaseVoltage == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(),
                                   values: ElectricArcFurnaceData.LampBaseVoltage.arrayStringValues(),
                                   selectedIndex: ElectricArcFurnaceData.sharedInstance.lampBaseVoltage?.index(),
                                   indexPath: indexPath,
                                   valid: valid)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
            } else {
                assert(false, "Unknown RowData for cellForRowAtIndexPath: \(indexPath) - \(String(describing: rowData))")
            }
            
            return cell
            
        } else {
            assert(false, "Unknown RowData for cellForRowAtIndexPath: \(indexPath) - \(String(describing: rowData))")
            return UITableViewCell()
        } 
    }
}

// MARK: - UITextField Protocol + Methods
extension ElectricArcFurnaceInputView : UITextFieldDelegate {
    
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
            let rowData = RowData(rawValue: (indexPath as NSIndexPath).row)
            rowData?.setNewElectricArcFurnacePropertyValue(textField.text)
        }
        
        if let rootiPhoneViewController = AppDelegate.rootViewController() as? RootiPhoneViewController {
            rootiPhoneViewController.hideDoneButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let indexPath = textField.indexPath {
            
            if (indexPath as NSIndexPath).row == RowData.furnaceSize.rawValue {
                textField.resignFirstResponder()
            } else {
                if let nextIndexPath = ElectricArcFurnaceInputView.nextIndexPath(indexPath as IndexPath) {
                    self.indexPathOfCellToBecomeNextFirstResponder = nextIndexPath
                    
                    if let _ = self.tableView.cellForRow(at: nextIndexPath) {
                        self.makeFirstResponder(nextIndexPath)
                    } else {
                        self.tableView.scrollToRow(at: nextIndexPath, at: .top, animated: true)
                    }
                }
            }
        } else {
            assert(false, "textfield was expected to have an indexPath property!")
        }
        
        return true
    }
    
    fileprivate static func nextIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        if (indexPath as NSIndexPath).row >= RowData.count() - 1 {
            return nil
        } else {
            var nextIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: (indexPath as NSIndexPath).section)
            
            var rowData = RowData(rawValue: (nextIndexPath as NSIndexPath).row)
            
            while ElectricArcFurnaceInputView.cellIsNotSelectable(rowData!) == true {
                    
                    let nextRow = (nextIndexPath as NSIndexPath).row + 1
                    
                    if nextRow >= RowData.count() {
                        return nil
                    }
                    
                    nextIndexPath = IndexPath(row: nextRow, section: (nextIndexPath as NSIndexPath).section)
                    rowData = RowData(rawValue: (nextIndexPath as NSIndexPath).row)
            }
            
            return nextIndexPath
        }
    }
    
    fileprivate func makeFirstResponder(_ indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? SingleInputTableViewCell {
            cell.makeInputFieldFirstResponder()
        }
        self.indexPathOfCellToBecomeNextFirstResponder = nil
    }
}


// MARK: - Electric Arc Furnace Protocol
extension ElectricArcFurnaceInputView : ElectricArcFurnaceProtocol {
    func electricArcFurnaceDataDidChange() {
        self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
    
    func electricArcFurnaceDataDidReset() {
        self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
}

// MARK: - Multiple Selection Protocol
extension ElectricArcFurnaceInputView : SelectionTableViewProtocol {
    func didSelectItem(_ item: String, index: Int) {
        if let indexPath = self.indexPathForMultipleSelectionPopover {
            if (indexPath as NSIndexPath).row == RowData.highReactanceDesign.rawValue {
                ElectricArcFurnaceData.sharedInstance.highReactanceDesign = ElectricArcFurnaceData.HighReactanceDesign(rawValue: item)
            } else if (indexPath as NSIndexPath).row == RowData.furnaceType.rawValue {
                ElectricArcFurnaceData.sharedInstance.furnaceType = ElectricArcFurnaceData.FurnaceType(rawValue: item)
            } else if (indexPath as NSIndexPath).row == RowData.compensation.rawValue {
                ElectricArcFurnaceData.sharedInstance.compensation = ElectricArcFurnaceData.Compensation(rawValue: item)
            } else if (indexPath as NSIndexPath).row == RowData.lampBaseVoltage.rawValue {
                ElectricArcFurnaceData.sharedInstance.lampBaseVoltage = ElectricArcFurnaceData.LampBaseVoltage(rawValue: item)
            } else {
                assert(false, "unhanlded multiple selection protocol call!")
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UIPopoverPresentationController Protocol
extension ElectricArcFurnaceInputView : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.indexPathForMultipleSelectionPopover = nil
    }
}
