//
//  RepetitiveLoadInputView.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class RepetitiveLoadInputView: UIView {

    @IBOutlet weak var container: StyledContainer!
    @IBOutlet weak var containerLeadingPadding: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingPadding: NSLayoutConstraint!
    @IBOutlet weak var containerTopPadding: NSLayoutConstraint!
    @IBOutlet weak var containerBottomPadding: NSLayoutConstraint!
    
    fileprivate enum RowData : Int {
        case shapeType = 0
        case changeUnit
        case changeRate
        case deltaVV
        case deltaVVAtPCC
        case timeOne
        case timeTwo
        case durationOfVoltageChange
        case shapeFactor
        case loadAmpsResultingInDeltaVVAtPCC
        
        static func count() -> Int {
            return RowData.loadAmpsResultingInDeltaVVAtPCC.rawValue + 1
        }
        
        func name() -> String {
            if self == .shapeType {
                return RepetitiveLoadData.SHAPE_TYPE
            } else if self == .changeUnit {
                return RepetitiveLoadData.CHANGE_UNIT
            } else if self == .changeRate {
                return RepetitiveLoadData.CHANGE_RATE
            } else if self == .deltaVV {
                // TODO: Implement in repetitive load data class!
                return "NOT IMPLEMENTED"
            } else if self == .deltaVVAtPCC {
                return RepetitiveLoadData.DELTA_VV_AT_PCC
            } else if self == .timeOne {
                return RepetitiveLoadData.TIME_ONE
            } else if self == .timeTwo {
                return RepetitiveLoadData.TIME_TWO
            } else if self == .durationOfVoltageChange {
                return RepetitiveLoadData.DURATION_OF_VOLTAGE_CHANGE
            } else if self == .shapeFactor {
                return RepetitiveLoadData.SHAPE_FACTOR
            } else if self == .loadAmpsResultingInDeltaVVAtPCC {
                return RepetitiveLoadData.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC
            } else {
                assert(false, "no RowData name found for \(self)")
                return "....fail..."
            }
        }
        
        func setNewRepetitiveLoadPropertyValue(_ value: String?) -> String? {
            let doubleValue = (value != nil) ? Double(value!) : nil
        
            var errors : String?
            
            if self == .changeRate {
                RepetitiveLoadData.sharedInstance.changeRate = doubleValue
                
                
                if let changeRate = RepetitiveLoadData.sharedInstance.changeRate,
                    let changeUnit = RepetitiveLoadData.sharedInstance.changeUnit,
                    let shapeType = RepetitiveLoadData.sharedInstance.shapeType {

                    
                    errors = RepetitiveLoadData.changeRateIsValid(shapeType,
                                                                  changeRate: changeRate,
                                                                  changeUnit: changeUnit).errorMessage
                    
                }
                
            } else if self == .deltaVV {
                // TODO: Implement once RepetitiveLoadData has DeltaVV property!
            } else if self == .deltaVVAtPCC {
                RepetitiveLoadData.sharedInstance.deltaVVAtPCC = doubleValue
            } else if self == .durationOfVoltageChange {
                RepetitiveLoadData.sharedInstance.durationOfVoltageChange = doubleValue
                
                if let durationOfVoltageChange = RepetitiveLoadData.sharedInstance.durationOfVoltageChange,
                    let shapeType = RepetitiveLoadData.sharedInstance.shapeType {
                    
                    errors = RepetitiveLoadData.durationOfVoltageChangeIsValid(shapeType,
                                                                               durationOfVoltageChange: durationOfVoltageChange).errorMessage
                    
                }
                
            } else if self == .loadAmpsResultingInDeltaVVAtPCC {
                RepetitiveLoadData.sharedInstance.loadAmpsResultingInDeltaVVPercentAtPCC = doubleValue
            } else {
                assert(false, "No Konwn Settable RepetitiveLoadData property for \(self)")
            }
            return errors
        }
        
        func arrayStringValues() -> [String]? {
            
            if self == .shapeType {
                return RepetitiveLoadData.ShapeType.itemArray
            } else if self == .changeUnit {
                return RepetitiveLoadData.ChangeUnit.arrayStringValues()
            } else if self == .timeOne {
                return RepetitiveLoadData.TimeOne.arrayStringValues()
            } else if self == .timeTwo {
                return RepetitiveLoadData.TimeTwo.arrayStringValues()
            } else {
                assert(false, "should only call this on ChangeUnit, TimeOne and TimeTwo. You called it on \(self)")
            }
            
            return nil
        }
    }
    
    @IBOutlet var shapeTypeSegmentedControlContainer: UIView!
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
        
        RepetitiveLoadData.sharedInstance.delegates.append(self)
        
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
    
    // MARK: - Subview Configuration

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
            if rowData == .shapeType {
                index = RepetitiveLoadData.sharedInstance.shapeType?.index()
            } else if rowData == .changeUnit {
                index = RepetitiveLoadData.sharedInstance.changeUnit?.index()
            } else if rowData == .timeOne {
                index = RepetitiveLoadData.sharedInstance.timeOne?.index()
            } else if rowData == .timeTwo {
                index = RepetitiveLoadData.sharedInstance.timeTwo?.index()
            } else {
                assert(false, "No index for multiple selection popover for rowData \(rowData)")
            }
            
            selectionTableViewController.configure(rowData.arrayStringValues()!, selectedIndex: index, title: rowData.name())
        }
    }
    
    // MARK: - Utility Methods
    fileprivate static func cellShouldBeHidden(_ rowData: RowData) -> Bool {
        
        if RepetitiveLoadData.sharedInstance.shapeType == .Rectangular ||
            RepetitiveLoadData.sharedInstance.shapeType == .Sinusoidal ||
            RepetitiveLoadData.sharedInstance.shapeType == .Triangular {
            if rowData == .durationOfVoltageChange {
                return true
            }
        }
        
        if RepetitiveLoadData.sharedInstance.shapeType != .Aperiodic {
            if rowData == .timeOne {
                return true
            } else if rowData == .timeTwo {
                return true
            }
        }
        
        if RepetitiveLoadData.sharedInstance.shapeType == .Aperiodic {
            if rowData == .changeRate ||
                rowData == .changeUnit ||
                rowData == .deltaVV ||
                rowData == .durationOfVoltageChange ||
                rowData == .shapeFactor {
                return true
            }
        }
        
        return false
    }
    
    fileprivate static func cellInputShouldBeDisabled(_ rowData: RowData) -> Bool {
        
        if rowData == .deltaVV {
            return true
        } else if rowData == .shapeFactor {
            return true
        }
        
        return false
    }
    
    fileprivate static func cellIsNotSelectable(_ rowData: RowData) -> Bool {
        
        if rowData == .deltaVV {
            return true
        } else if rowData == .shapeFactor {
            return true
        } else if rowData == .timeOne {
            return true
        } else if rowData == .timeTwo {
            return true
        } else if rowData == .changeUnit {
            return true
        }
        
        return false
    }
    
    fileprivate func showInvalidInputAlertViewMessage(_ message: String, indexPaths: [IndexPath], title: String = "Invalid Input", actionText: String = "Ok") {
        
        let alertController = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.problemBaseViewController.present(alertController, animated: true, completion: nil)
        
        self.tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}

// MARK: - UITablewView Delegate/DataSource
extension RepetitiveLoadInputView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowData.count()
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowData = RowData(rawValue: (indexPath as NSIndexPath).row)
        let cellHidden = RepetitiveLoadInputView.cellShouldBeHidden(rowData!)
        
        if cellHidden == true {
            return 0
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = self.indexPathOfCellToBecomeNextFirstResponder {
            self.makeFirstResponder(indexPath)
        }
    }
}

extension RepetitiveLoadInputView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowData = RowData.init(rawValue: (indexPath as NSIndexPath).row)
        
        if rowData == .shapeType ||
            rowData == .changeUnit ||
            rowData == .timeOne ||
            rowData == .timeTwo {
            
            var cell : MultipleSelectionTableViewCell!
            
            cell = tableView.dequeueReusableCell(withIdentifier: MultipleSelectionTableViewCell.reuseID()) as? MultipleSelectionTableViewCell
            if cell == nil {
                cell = MultipleSelectionTableViewCell()
            }
            
            if rowData == .shapeType {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.shapeType == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(), values: RepetitiveLoadData.ShapeType.itemArray, selectedIndex: RepetitiveLoadData.sharedInstance.shapeType?.index(), indexPath: indexPath, valid: valid)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
                
            } else if rowData == .changeUnit {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.changeUnit == nil {
                    valid = false
                } else if let changeRate = RepetitiveLoadData.sharedInstance.changeRate,
                    let changeUnit = RepetitiveLoadData.sharedInstance.changeUnit,
                    let shapeType = RepetitiveLoadData.sharedInstance.shapeType {
                    
                    valid = RepetitiveLoadData.changeRateIsValid(shapeType,
                                                                 changeRate: changeRate,
                                                                 changeUnit: changeUnit).valid
                }
                
                cell.configureCell(rowData!.name(), values: RepetitiveLoadData.ChangeUnit.arrayStringValues(), selectedIndex: RepetitiveLoadData.sharedInstance.changeUnit?.index(), indexPath: indexPath, valid: valid, selectionEnabled: true, showSeperatorView: false)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
            } else if rowData == .timeOne {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.timeOne == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(), values: RepetitiveLoadData.TimeOne.arrayStringValues(), selectedIndex: RepetitiveLoadData.sharedInstance.timeOne?.index(), indexPath: indexPath, valid: valid)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
            } else if rowData == .timeTwo {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.timeTwo == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(), values: RepetitiveLoadData.TimeTwo.arrayStringValues(), selectedIndex: RepetitiveLoadData.sharedInstance.timeTwo?.index(), indexPath: indexPath, valid: valid)
                cell.multipleSelectionView!.selectionButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                cell.multipleSelectionView!.selectionButton.addTarget(self, action: #selector(multipleSelectionPopoverButtonPressed), for: .touchUpInside)
            } else {
                assert(false, "Unknown RowData for cellForRowAtIndexPath: \(indexPath) - \(String(describing: rowData))")
            }
            
            let cellHidden = RepetitiveLoadInputView.cellShouldBeHidden(rowData!)
            cell.isHidden = cellHidden
        
            return cell
            
        } else {
            
            var cell : SingleInputTableViewCell!
            
            cell = tableView.dequeueReusableCell(withIdentifier: SingleInputTableViewCell.reuseID()) as? SingleInputTableViewCell
            if cell == nil {
                cell = SingleInputTableViewCell()
            }
            
            if rowData == .changeRate {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.changeRate == nil {
                    valid = false
                } else if let changeRate = RepetitiveLoadData.sharedInstance.changeRate,
                    let changeUnit = RepetitiveLoadData.sharedInstance.changeUnit,
                    let shapeType = RepetitiveLoadData.sharedInstance.shapeType {
                    
                    valid = RepetitiveLoadData.changeRateIsValid(shapeType,
                                                                 changeRate: changeRate,
                                                                 changeUnit: changeUnit).valid
                }
                cell.configureCell(rowData!.name(), value:RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.changeRate, decimalPlaces: 2, emptyValue: ""), indexPath: indexPath, valid: valid, inputEnabled: true, showSeperatorView: true)
                cell.singleInputView?.inputTextField.delegate = self
            } else if rowData == .deltaVV {
                
                var value = "---"
                if let changeRate = RepetitiveLoadData.sharedInstance.changeRate,
                    let changeUnit = RepetitiveLoadData.sharedInstance.changeUnit {
                    
                    value = RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.calculateDPstOne(changeRate, changeUnit: changeUnit))
                }
                
                
                cell.configureCell("delta V/V (%)", value: value, indexPath: indexPath, valid: true, inputEnabled: false)
                cell.singleInputView?.inputTextField.delegate = self
            } else if rowData == .deltaVVAtPCC {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.deltaVVAtPCC == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(), value: RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.deltaVVAtPCC), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            } else if rowData == .durationOfVoltageChange {
                
                var valid = true
                
                if let durationOfVoltageChange = RepetitiveLoadData.sharedInstance.durationOfVoltageChange,
                    let shapeType = RepetitiveLoadData.sharedInstance.shapeType {
                    
                    valid = RepetitiveLoadData.durationOfVoltageChangeIsValid(shapeType,
                                                                              durationOfVoltageChange: durationOfVoltageChange).valid
                    
                } else {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(), value: RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.durationOfVoltageChange), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
            }  else if rowData == .shapeFactor {
                
                cell.configureCell(rowData!.name(), value: RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.shapeFactor), indexPath: indexPath, valid: true, inputEnabled: false)
                cell.singleInputView?.inputTextField.delegate = self
            }  else if rowData == .loadAmpsResultingInDeltaVVAtPCC {
                
                var valid = true
                if RepetitiveLoadData.sharedInstance.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
                    valid = false
                }
                
                cell.configureCell(rowData!.name(), value: RepetitiveLoadData.formattedDoubleValue(RepetitiveLoadData.sharedInstance.loadAmpsResultingInDeltaVVPercentAtPCC), indexPath: indexPath, valid: valid)
                cell.singleInputView?.inputTextField.delegate = self
                cell.singleInputView?.inputTextField.returnKeyType = .done
            } else {
                assert(false, "Unknown RowData for cellForRowAtIndexPath: \(indexPath) - \(String(describing: rowData))")
            }
            
            let cellHidden = RepetitiveLoadInputView.cellShouldBeHidden(rowData!)
            cell.isHidden = cellHidden
            
            return cell
        }
    }
}


// MARK: - UITextField Protocol + Methods
extension RepetitiveLoadInputView : UITextFieldDelegate {
    
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
            if let inputInvalidMessage = rowData?.setNewRepetitiveLoadPropertyValue(textField.text) {
                
                self.showInvalidInputAlertViewMessage(inputInvalidMessage, indexPaths: [indexPath as IndexPath])
                
            }
        }
        
        if let rootiPhoneViewController = AppDelegate.rootViewController() as? RootiPhoneViewController {
            rootiPhoneViewController.hideDoneButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let indexPath = textField.indexPath {
            
            if (indexPath as NSIndexPath).row >= RowData.count() - 1 {
                textField.resignFirstResponder()
            } else {
                if let nextIndexPath = RepetitiveLoadInputView.nextIndexPath(indexPath as IndexPath) {
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
            
            while RepetitiveLoadInputView.cellShouldBeHidden(rowData!) == true ||
                RepetitiveLoadInputView.cellInputShouldBeDisabled(rowData!) == true ||
                RepetitiveLoadInputView.cellIsNotSelectable(rowData!) == true {
                    
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
        
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if let cell = cell as? SingleInputTableViewCell {
            cell.makeInputFieldFirstResponder()
        }
        
        self.indexPathOfCellToBecomeNextFirstResponder = nil
    }
}

// MARK: - Repetitive Load Protocol
extension RepetitiveLoadInputView : RepetitiveLoadProtocol {
    func shapeTypeDidChange() {
        self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
    
    func repetitiveLoadDataDidChange() {
        self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
    
    
    func repetitiveLoadDataDidReset() {
        self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
}

// MARK: - GMSWSegmentedControl Protocol
extension RepetitiveLoadInputView : GMSWSegmentedControlDelegate {
    func valueDidChange(_ index: Int, item: String) {
        
        let shapeType = RepetitiveLoadData.ShapeType(rawValue: item)
        assert(shapeType != nil, "Could not find shape type from rawValue \(item)")
        RepetitiveLoadData.sharedInstance.shapeType = shapeType
    }
}

// MARK: - Multiple Selection Protocol
extension RepetitiveLoadInputView : SelectionTableViewProtocol {
    func didSelectItem(_ item: String, index: Int) {
        if let indexPath = self.indexPathForMultipleSelectionPopover {
            
            if (indexPath as NSIndexPath).row == RowData.shapeType.rawValue {
                RepetitiveLoadData.sharedInstance.shapeType = RepetitiveLoadData.ShapeType(rawValue: item)
            } else if (indexPath as NSIndexPath).row == RowData.changeUnit.rawValue {
                RepetitiveLoadData.sharedInstance.changeUnit = RepetitiveLoadData.ChangeUnit(rawValue: item)
                
                if let changeRate = RepetitiveLoadData.sharedInstance.changeRate,
                    let changeUnit = RepetitiveLoadData.sharedInstance.changeUnit,
                    let shapeType = RepetitiveLoadData.sharedInstance.shapeType {
                    
                    let errors = RepetitiveLoadData.changeRateIsValid(shapeType,
                                                                      changeRate: changeRate,
                                                                      changeUnit: changeUnit)
                    if errors.valid == false {
                        
                        self.showInvalidInputAlertViewMessage(errors.errorMessage!, indexPaths: [indexPath, IndexPath(row: RowData.changeRate.rawValue, section: 0)], title: "Change Rate is Now Invalid", actionText: "Ok")
                        
                    }
                }
                
            } else if (indexPath as NSIndexPath).row == RowData.timeOne.rawValue {
                RepetitiveLoadData.sharedInstance.timeOne = RepetitiveLoadData.TimeOne(rawValue: item)
            } else if (indexPath as NSIndexPath).row == RowData.timeTwo.rawValue {
                RepetitiveLoadData.sharedInstance.timeTwo = RepetitiveLoadData.TimeTwo(rawValue: item)
            } else {
                assert(false, "unhandled multiple selection protocol call!")
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UIPopoverPresentationController Protocol
extension RepetitiveLoadInputView : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.indexPathForMultipleSelectionPopover = nil
    }
}
