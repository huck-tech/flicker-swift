//
//  Self.swift
//  Flicker
//
//  Created by Anders Melen on 5/17/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import Foundation

protocol FlickerLimitProtocol {
    func flickerLimitsDidChange()
    func flickerLimitsDidReset()
}

class FlickerLimits: NSUserDefaultSyncable {
    
    fileprivate typealias `Self` = FlickerLimits
    
    static let HELP_PDF_URL = Bundle.main.path(forResource: "Help_Flicker_Limits", ofType: "pdf")!
    static let HELP_TITLE = "Flicker Limits Help"
    
    // MARK: - Delegates
    var delegates = [FlickerLimitProtocol]()
    
    // MARK: - NSUserDefault Keys
    static let UPSTREAM_SYSTEM_RATED_VOLTAGE = "Upstream System Rated Voltage (KV)"
    static let PCC_RATED_VOLTAGE = "PCC Rated Voltage (KV)"
    static let BACKGROUND_FLICKER = "Background Flicker"
    
    static let UPSTREAM_PLANNING_LEVEL = "Upstream Planning Level (L_Pst_US)"
    static let UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT = "Upstream System to PCC Transfer Coefficient (Tpst)"
    static let PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT = "PCC to Upstream Transfer Coefficient (Tpst_US)"
    static let PCC_PLANNING_LEVEL = "PCC Planning Level (L_Pst_PCC)"
    static let SUMMATION_LAW_EXPONENT = "Summation Law Exponent (alpha)"
    static let SIZE_OF_PCC_UNDER_LOAD = "Size of Load Connected to PCC (S_Load)"
    static let TOTAL_CAPACITY_OF_SYSTEM_AT_PCC_AND_LV_IN_MVA = "Total Capacity of System at PCC in MVA (S_Total)"
    static let TOTAL_POWER_OF_LOAD_IN_LV_SYSTEM_IN_MVA = "Total Power of Load in LV System in MVA (S_LV)"
    
    static let MANUAL_MODE = "manualMode"
    
    static let MANUAL_MAXIMUM_GLOBAL_CONTRIBUTION_AT_PCC = "manualMaximumGlobalContributionAtPCC"
    static let MANUAL_EMISSION_LIMIT = "manualEmissionLimit"
    
    // MARK: - Parameters
    // MARK: Mode
    fileprivate var _manualMode : Bool!
    var manualMode : Bool! {
        set {
            if newValue != _manualMode {
                _manualMode = newValue
        
                Self.saveObjectToNSUserDefaults(Self.MANUAL_MODE, value: self.manualMode as AnyObject?)
         
                if newValue == true {
                    self.setManualOutputParameters()
                } else {
                    self.recalculateOutputParameters()
                }
                
            }
        }
        get { return _manualMode }
    }
    
    // MARK: Outputs
    fileprivate var _manualMaximumGlobalContributionApPCC : Double?
    var manualMaximumGlobalContributionApPCC : Double? {
        set {
            assert(self.manualMode == true, "Trying to set manual value when not in manual mode!")
            if newValue != _manualMaximumGlobalContributionApPCC {
                _manualMaximumGlobalContributionApPCC = newValue
                self.maximumGlobalContributionAtPCC = newValue
                
                Self.saveObjectToNSUserDefaults(Self.MANUAL_MAXIMUM_GLOBAL_CONTRIBUTION_AT_PCC, value: self.manualMaximumGlobalContributionApPCC as AnyObject?)
                
                self.notifyDelegatesOfLimitChanges()
            }
        }
        get { return _manualMaximumGlobalContributionApPCC }
    }
    
    fileprivate var _manualEmissionLimit : Double?
    var manualEmissionLimit : Double? {
        set {
            assert(self.manualMode == true, "Trying to set manual value when not in manual mode!")
            if newValue != _manualEmissionLimit {
                _manualEmissionLimit = newValue
                self.emissionLimit = newValue
                
                Self.saveObjectToNSUserDefaults(Self.MANUAL_EMISSION_LIMIT, value: self.manualEmissionLimit as AnyObject?)
                
                self.notifyDelegatesOfLimitChanges()
            }
        }
        get { return _manualEmissionLimit }
    }
    
    fileprivate var _maximumGlobalContributionAtPCC: Double?
    var maximumGlobalContributionAtPCC: Double? {
        set {
            if newValue != _maximumGlobalContributionAtPCC {
                _maximumGlobalContributionAtPCC = newValue
                
                self.notifyDelegatesOfLimitChanges()
            }
        }
        get { return _maximumGlobalContributionAtPCC }
    }
    
    fileprivate var _emissionLimit: Double?
    var emissionLimit: Double? {
        set {
            if newValue != _emissionLimit {
                _emissionLimit = newValue
                
                self.notifyDelegatesOfLimitChanges()
            }
        }
        get { return _emissionLimit }
    }
    
    
    // MARK: Inputs
    fileprivate var _upstreamSystemRatedVoltage: Double?
    var upstreamSystemRatedVoltage : Double? {
        set {
            
            if newValue != _upstreamSystemRatedVoltage {
                _upstreamSystemRatedVoltage = newValue
                
                Self.saveObjectToNSUserDefaults(Self.UPSTREAM_SYSTEM_RATED_VOLTAGE, value: self.upstreamSystemRatedVoltage as AnyObject?)
                
                self.recalculateOutputParameters()
            }
            
            if self.upstreamPlanningLevel == nil {
                self.autoSetUpstreamPlanningLevel()
            }
        }
        get { return _upstreamSystemRatedVoltage }
    }
    
    fileprivate var _pccRatedVoltage: Double?
    var pccRatedVoltage : Double? {
        set {
            
            if newValue != _pccRatedVoltage {
                _pccRatedVoltage = newValue
                
                Self.saveObjectToNSUserDefaults(Self.PCC_RATED_VOLTAGE, value: self.pccRatedVoltage as AnyObject?)
                
                self.recalculateOutputParameters()
            }
            
            if self.pccPlanningLevel == nil {
                self.autoSetPccPlanningLevel()
            }
        }
        get { return _pccRatedVoltage }
    }
    
    fileprivate var _backgroundFlicker: Double?
    var backgroundFlicker : Double? {
        set {
            if newValue != _backgroundFlicker {
                _backgroundFlicker = newValue
                
                Self.saveObjectToNSUserDefaults(Self.BACKGROUND_FLICKER, value: self.backgroundFlicker as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _backgroundFlicker }
    }
    
    fileprivate var _upstreamPlanningLevel: Double?
    var upstreamPlanningLevel : Double? {
        set {
            if newValue != _upstreamPlanningLevel {
                _upstreamPlanningLevel = newValue
                Self.saveObjectToNSUserDefaults(Self.UPSTREAM_PLANNING_LEVEL, value: self.upstreamPlanningLevel as AnyObject?)
                UserDefaults.standard.synchronize()
                self.recalculateOutputParameters()
            }
        }
        get { return _upstreamPlanningLevel }
    }
    
    fileprivate var _upstreamSystemToPCCTransferCoefficient: Double?
    var upstreamSystemToPCCTransferCoefficient : Double? {
        set {
            if newValue != _upstreamSystemToPCCTransferCoefficient {
                _upstreamSystemToPCCTransferCoefficient = newValue
                
                Self.saveObjectToNSUserDefaults(Self.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT, value: self.upstreamSystemToPCCTransferCoefficient as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _upstreamSystemToPCCTransferCoefficient }
    }
    
    fileprivate var _pccToUpstreamSystemTransferCoefficient: Double?
    var pccToUpstreamSystemTransferCoefficient : Double? {
        set {
            if newValue != _pccToUpstreamSystemTransferCoefficient {
                _pccToUpstreamSystemTransferCoefficient = newValue
                
                Self.saveObjectToNSUserDefaults(Self.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT, value: self.pccToUpstreamSystemTransferCoefficient as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _pccToUpstreamSystemTransferCoefficient }
    }
    
    fileprivate var _pccPlanningLevel: Double?
    var pccPlanningLevel : Double? {
        set {
            if newValue != _pccPlanningLevel {
                _pccPlanningLevel = newValue
                
                Self.saveObjectToNSUserDefaults(Self.PCC_PLANNING_LEVEL, value: self.pccPlanningLevel as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _pccPlanningLevel }
    }
    
    fileprivate var _summationLawExponent: Double?
    var summationLawExponent : Double? {
        set {
            if newValue != _summationLawExponent {
                _summationLawExponent = newValue
                
                Self.saveObjectToNSUserDefaults(Self.SUMMATION_LAW_EXPONENT, value: self.summationLawExponent as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _summationLawExponent }
    }
    
    fileprivate var _sizeOfPCCUnderLoad: Double?
    var sizeOfPCCUnderLoad : Double? {
        set {
            if newValue != _sizeOfPCCUnderLoad {
                _sizeOfPCCUnderLoad = newValue
                
                Self.saveObjectToNSUserDefaults(Self.SIZE_OF_PCC_UNDER_LOAD, value: self.sizeOfPCCUnderLoad as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _sizeOfPCCUnderLoad }
    }
    
    fileprivate var _totalCapacityOfSystemAtPCCAndLCInMVA: Double?
    var totalCapacityOfSystemAtPCCAndLCInMVA : Double? {
        set {
            if newValue != _totalCapacityOfSystemAtPCCAndLCInMVA {
                _totalCapacityOfSystemAtPCCAndLCInMVA = newValue
                
                Self.saveObjectToNSUserDefaults(Self.TOTAL_CAPACITY_OF_SYSTEM_AT_PCC_AND_LV_IN_MVA, value: self.totalCapacityOfSystemAtPCCAndLCInMVA as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _totalCapacityOfSystemAtPCCAndLCInMVA }
    }
    
    fileprivate var _totalPowerOfLoadInLVSystemInMVA: Double?
    var totalPowerOfLoadInLVSystemInMVA : Double? {
        set {
            if newValue != _totalPowerOfLoadInLVSystemInMVA {
                _totalPowerOfLoadInLVSystemInMVA = newValue
                
                Self.saveObjectToNSUserDefaults(Self.TOTAL_POWER_OF_LOAD_IN_LV_SYSTEM_IN_MVA, value: self.totalPowerOfLoadInLVSystemInMVA as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _totalPowerOfLoadInLVSystemInMVA }
    }
    
    // MARK: - Singlton Constructor
    static let sharedInstance = FlickerLimits()
    
    // MARK: - Constructor
    
    override init() {
        
        super.init()
        
        self.setDefaultValuesIfNil()
        
        self.loadFromNSUserDefaults()
        
        if self.manualMode == true {
            self.setManualOutputParameters()
        } else {
            self.recalculateOutputParameters()
        }
    }
    
    fileprivate func setDefaultValuesIfNil() {
        let manualMode: Bool? = Self.loadObjectFromNSUserDefaults(Self.MANUAL_MODE)
        if manualMode == nil {
            Self.saveObjectToNSUserDefaults(Self.MANUAL_MODE, value: false as AnyObject?)
        }
        
        let upstreamSystemToPCCTransferCoefficient: Double? = Self.loadObjectFromNSUserDefaults(Self.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT)
        if upstreamSystemToPCCTransferCoefficient == nil {
            Self.saveObjectToNSUserDefaults(Self.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT, value: 0.9 as AnyObject?)
        }
        
        let pccToUpstreamSystemTransferCoefficient: Double? = Self.loadObjectFromNSUserDefaults(Self.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT)
        if pccToUpstreamSystemTransferCoefficient == nil {
            Self.saveObjectToNSUserDefaults(Self.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT, value: 0.9 as AnyObject?)
        }
        
        let summationLawExponent: Double? = Self.loadObjectFromNSUserDefaults(Self.SUMMATION_LAW_EXPONENT)
        if summationLawExponent == nil {
            Self.saveObjectToNSUserDefaults(Self.SUMMATION_LAW_EXPONENT, value: 3.0 as AnyObject?)
        }
    }
    
    // MARK: - Resetting
    func reset() {
        
        Self.saveObjectToNSUserDefaults(Self.UPSTREAM_SYSTEM_RATED_VOLTAGE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.PCC_RATED_VOLTAGE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.BACKGROUND_FLICKER, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.UPSTREAM_PLANNING_LEVEL, value: nil)
        Self.saveObjectToNSUserDefaults(Self.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT, value: nil)
        Self.saveObjectToNSUserDefaults(Self.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT, value: nil)
        Self.saveObjectToNSUserDefaults(Self.PCC_PLANNING_LEVEL, value: nil)
        Self.saveObjectToNSUserDefaults(Self.SUMMATION_LAW_EXPONENT, value: nil)
        Self.saveObjectToNSUserDefaults(Self.SIZE_OF_PCC_UNDER_LOAD, value: nil)
        Self.saveObjectToNSUserDefaults(Self.TOTAL_CAPACITY_OF_SYSTEM_AT_PCC_AND_LV_IN_MVA, value: nil)
        Self.saveObjectToNSUserDefaults(Self.TOTAL_POWER_OF_LOAD_IN_LV_SYSTEM_IN_MVA, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.MANUAL_MODE, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.MANUAL_MAXIMUM_GLOBAL_CONTRIBUTION_AT_PCC, value: nil)
        Self.saveObjectToNSUserDefaults(Self.MANUAL_EMISSION_LIMIT, value: nil)
        
        self.manualMode = false
        
        self.setDefaultValuesIfNil()

        self.loadFromNSUserDefaults()
        
        for delegate in self.delegates {
            delegate.flickerLimitsDidReset()
        }
    }
    
    // MARK: - Error Reporting
    func missingInputString(_ seperator: String?) -> String {
        let missingInputs = self.missingInputs()
        
        var finalString = ""
        
        for i in 0 ..< missingInputs.count {
            
            finalString += missingInputs[i]
            
            if i < (missingInputs.count - 1) && seperator != nil {
                finalString += seperator!
            }
        }
        
        return finalString
    }
    
    func missingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.upstreamSystemRatedVoltage == nil {
            missing.append(Self.UPSTREAM_SYSTEM_RATED_VOLTAGE)
        }
        
        if self.pccRatedVoltage == nil {
            missing.append(Self.PCC_RATED_VOLTAGE)
        }
        
        if self.backgroundFlicker == nil {
            missing.append(Self.BACKGROUND_FLICKER)
        }
        
        if self.upstreamSystemToPCCTransferCoefficient == nil {
            missing.append(Self.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT)
        }
        
        if self.pccToUpstreamSystemTransferCoefficient == nil {
            missing.append(Self.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT)
        }
        
        if self.pccPlanningLevel == nil {
            missing.append(Self.PCC_PLANNING_LEVEL)
        }
        
        if self.summationLawExponent == nil {
            missing.append(Self.SUMMATION_LAW_EXPONENT)
        }
        
        if self.sizeOfPCCUnderLoad == nil {
            missing.append(Self.SIZE_OF_PCC_UNDER_LOAD)
        }
        
        if self.totalCapacityOfSystemAtPCCAndLCInMVA == nil {
            missing.append(Self.TOTAL_CAPACITY_OF_SYSTEM_AT_PCC_AND_LV_IN_MVA)
        }
        
        if self.totalPowerOfLoadInLVSystemInMVA == nil {
            missing.append(Self.TOTAL_POWER_OF_LOAD_IN_LV_SYSTEM_IN_MVA)
        }
        
        return missing
    }
    
    // NARK: - NSUserDefault Interface
    // MARK: Load
    func loadFromNSUserDefaults() {
        
        _upstreamSystemRatedVoltage = Self.loadObjectFromNSUserDefaults(Self.UPSTREAM_SYSTEM_RATED_VOLTAGE)
        _pccRatedVoltage = Self.loadObjectFromNSUserDefaults(Self.PCC_RATED_VOLTAGE)
        _backgroundFlicker = Self.loadObjectFromNSUserDefaults(Self.BACKGROUND_FLICKER)
        
        _upstreamPlanningLevel = Self.loadObjectFromNSUserDefaults(Self.UPSTREAM_PLANNING_LEVEL)
        _upstreamSystemToPCCTransferCoefficient = Self.loadObjectFromNSUserDefaults(Self.UPSTREAM_SYSTEM_TO_PCC_TRANSFER_COEFFICIENT)
        _pccToUpstreamSystemTransferCoefficient = Self.loadObjectFromNSUserDefaults(Self.PCC_TO_UPSTREAM_TRANSFER_COEFFICIENT)
        _pccPlanningLevel = Self.loadObjectFromNSUserDefaults(Self.PCC_PLANNING_LEVEL)
        _summationLawExponent = Self.loadObjectFromNSUserDefaults(Self.SUMMATION_LAW_EXPONENT)
        _sizeOfPCCUnderLoad = Self.loadObjectFromNSUserDefaults(Self.SIZE_OF_PCC_UNDER_LOAD)
        _totalCapacityOfSystemAtPCCAndLCInMVA = Self.loadObjectFromNSUserDefaults(Self.TOTAL_CAPACITY_OF_SYSTEM_AT_PCC_AND_LV_IN_MVA)
        _totalPowerOfLoadInLVSystemInMVA = Self.loadObjectFromNSUserDefaults(Self.TOTAL_POWER_OF_LOAD_IN_LV_SYSTEM_IN_MVA)
        
        _manualMode = Self.loadObjectFromNSUserDefaults(Self.MANUAL_MODE)
        
        _manualMaximumGlobalContributionApPCC = Self.loadObjectFromNSUserDefaults(Self.MANUAL_MAXIMUM_GLOBAL_CONTRIBUTION_AT_PCC)
        _manualEmissionLimit = Self.loadObjectFromNSUserDefaults(Self.MANUAL_EMISSION_LIMIT)
    }
    
    
    // MARK: - Auto-Set Values
    func autoSetUpstreamPlanningLevel() {
        
        if let upstreamSystemRatedVoltage = self.upstreamSystemRatedVoltage {
            if upstreamSystemRatedVoltage > 35.0 {
                self.upstreamPlanningLevel = 0.8
            } else {
                self.upstreamPlanningLevel = 0.9
            }
        }

    }
    
    func autoSetPccPlanningLevel() {
        
        if let pccRatedVoltage = self.pccRatedVoltage {
            if pccRatedVoltage > 35.0 {
                self.pccPlanningLevel = 0.8
            } else {
                self.pccPlanningLevel = 0.9
            }
        }
        
    }
    
    // MARK: - Formatted Output Strings
    static func formattedDoubleValue(_ value: Double?, emptyValue: String = "") -> String {
        if let value = value {
            return String.init(format: "%.2f", value)
        } else {
            return emptyValue
        }
    }
    
    func formattedMaximumGlobalContributionString(_ emptyValue: String = "---") -> String {
        if let maximumGobalContributionAtPCC = self.maximumGlobalContributionAtPCC {
            return String.init(format: "%.2f", maximumGobalContributionAtPCC)
        } else {
            return emptyValue
        }
    }
    
    func formattedEmissionLimitString(_ emptyValue: String = "---") -> String {
        if let emissionLimit = self.emissionLimit {
            return String.init(format: "%.2f", emissionLimit)
        } else {
            return emptyValue
        }
    }
    
    // MARK: - Outputs
    fileprivate func setManualOutputParameters() {
        self.maximumGlobalContributionAtPCC = _manualMaximumGlobalContributionApPCC
        self.emissionLimit = _manualEmissionLimit
    }
    
    fileprivate func recalculateOutputParameters(_ notifyDelegatesOfChanges: Bool = true) {
        
        if self.manualMode == true {
            return
        }
        
        if let pccPlanningLevel = self.pccPlanningLevel,
            let upstreamSystemToPCCTransferCoefficient = self.upstreamSystemToPCCTransferCoefficient,
            let upstreamPlanningLevel = self.upstreamPlanningLevel,
            let summationLawExponent = self.summationLawExponent {
            
            self.maximumGlobalContributionAtPCC = Self.calcuateMaximumGlobalContributionAtPCC(pccPlanningLevel,
                                                                                              upstreamSystemToPCCTransferCoefficient: upstreamSystemToPCCTransferCoefficient,
                                                                                              upstreamPlanningLevel: upstreamPlanningLevel,
                                                                                              summationLawExponent: summationLawExponent)
            
        } else {
            self.maximumGlobalContributionAtPCC = nil
        }
        
        if let sizeOfPCCUnderLoad = self.sizeOfPCCUnderLoad,
            let totalCapacityOfSystemAtPCCAndLCInMVA = self.totalCapacityOfSystemAtPCCAndLCInMVA,
            let totalPowerOfLoadInLVSystemInMVA = self.totalPowerOfLoadInLVSystemInMVA,
            let summationLawExponent = self.summationLawExponent,
            let maximumGlobalContributionAtPCC = self.maximumGlobalContributionAtPCC {
            
            self.emissionLimit = Self.calculateEmissionLimit(sizeOfPCCUnderLoad,
                                                                      totalCapacityOfSystemAtPCCAndLCInMVA: totalCapacityOfSystemAtPCCAndLCInMVA,
                                                                      totalPowerOfLoadInLVSystemInMVA: totalPowerOfLoadInLVSystemInMVA,
                                                                      summationLawExponent: summationLawExponent,
                                                                      maximumGlobalContributionAtPCC: maximumGlobalContributionAtPCC)
        } else {
            self.emissionLimit = nil
        }
        
        if notifyDelegatesOfChanges {
            self.notifyDelegatesOfLimitChanges()
        }
    }
    
    fileprivate func notifyDelegatesOfLimitChanges() {
        for delegate in self.delegates {
            delegate.flickerLimitsDidChange()
        }
    }
    
    // Mark: Algorithms
    internal static func calcuateMaximumGlobalContributionAtPCC(_ pccPlanningLevel: Double,
                                                        upstreamSystemToPCCTransferCoefficient: Double,
                                                        upstreamPlanningLevel: Double,
                                                        summationLawExponent: Double) -> Double {
        
        let componentA = pow(pccPlanningLevel, summationLawExponent)
        let componentB = pow(upstreamSystemToPCCTransferCoefficient, summationLawExponent)
        let componentC = pow(upstreamPlanningLevel, summationLawExponent)
        
        var maximumGlobalContributionAtPCC = pow(componentA - componentB * componentC, (1.0/summationLawExponent))
        
        if maximumGlobalContributionAtPCC.isNaN {
            maximumGlobalContributionAtPCC = 0.0
        }
        
        return maximumGlobalContributionAtPCC
    }
    
    internal static func calculateEmissionLimit(_ sizeOfPCCUnderLoad: Double,
                                        totalCapacityOfSystemAtPCCAndLCInMVA: Double,
                                        totalPowerOfLoadInLVSystemInMVA: Double,
                                        summationLawExponent: Double,
                                        maximumGlobalContributionAtPCC: Double) -> Double {
        
        let denominator = totalCapacityOfSystemAtPCCAndLCInMVA - totalPowerOfLoadInLVSystemInMVA
        let fraction = sizeOfPCCUnderLoad / denominator
        
        var emissionLimit = pow(fraction, (1.0/summationLawExponent)) * maximumGlobalContributionAtPCC
        
        if emissionLimit < 0.35 {
            emissionLimit = 0.35
        }
        
        return emissionLimit
    }
    
}
