//
//  ElectricArcFurnaceData.swift
//  Flicker
//
//  Created by Anders Melen on 5/31/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

protocol ElectricArcFurnaceProtocol {
    func electricArcFurnaceDataDidChange()
    func electricArcFurnaceDataDidReset()
}

class ElectricArcFurnaceData: NSUserDefaultSyncable {
    
    typealias CorrectionFactorRange = (lower: Double, upper: Double)
    
    enum FurnaceType : String {
        case AC = "AC"
        case DC = "DC"
        
        func correctionFactor() -> CorrectionFactorRange {
            if self == .AC {
                return (1.0, 1.0)
            } else if self == .DC {
                return (0.5, 0.75)
            } else {
                assert(false, "unrecognized type!")
                return (0.0, 0.0)
            }
        }
        
        static func arrayStringValues() -> [String] {
            return [FurnaceType.AC.rawValue,
                    FurnaceType.DC.rawValue]
        }
        
        func index() -> Int? {
            let arrayValues = FurnaceType.arrayStringValues()
            let index = arrayValues.index(of: self.rawValue)
            return index
        }
    }
    
    enum Compensation : String {
        case None = "None"
        case SVC = "SVC"
        case StatCom = "StatCom"
        
        func correctionFactor() -> CorrectionFactorRange {
            if self == .None {
                return (1.0, 1.0)
            } else if self == .SVC {
                return (0.5, 0.75)
            } else if self == .StatCom {
                return (0.17, 0.33)
            } else {
                assert(false, "unrecognized type!")
                return (0.0, 0.0)
            }
        }
        
        static func arrayStringValues() -> [String] {
            return [Compensation.None.rawValue,
                    Compensation.SVC.rawValue,
                    Compensation.StatCom.rawValue]
        }
        
        func index() -> Int? {
            let arrayValues = Compensation.arrayStringValues()
            let index = arrayValues.index(of: self.rawValue)
            return index
        }
    }
    
    enum LampBaseVoltage : String {
    
        case OneHundredAndTwentyVolts = "120v"
        case TwoHundredAndThirtyVolts = "230v"
        
        func correctionFactor() -> CorrectionFactorRange {
            if self == .OneHundredAndTwentyVolts {
                return (1.0, 1.0)
            } else if self == .TwoHundredAndThirtyVolts {
                return (1.2, 1.2)
            } else {
                assert(false, "unrecognized type!")
                return (0.0, 0.0)
            }
        }
        
        static func arrayStringValues() -> [String] {
            return [LampBaseVoltage.OneHundredAndTwentyVolts.rawValue,
                    LampBaseVoltage.TwoHundredAndThirtyVolts.rawValue]
        }
        
        func index() -> Int? {
            let arrayValues = LampBaseVoltage.arrayStringValues()
            let index = arrayValues.index(of: self.rawValue)
            return index
        }
    }
    
    enum HighReactanceDesign : String {
        case No = "No"
        case Yes = "Yes"
        
        func correctionFactor() -> CorrectionFactorRange {
            if self == .No {
                return (1.0, 1.0)
            } else if self == .Yes {
                return (0.8, 1.0)
            } else {
                assert(false, "unrecognized type!")
                return (0.0, 0.0)
            }
        }
        
        static func arrayStringValues() -> [String] {
            return [HighReactanceDesign.No.rawValue,
                    HighReactanceDesign.Yes.rawValue]
        }
        
        func index() -> Int? {
            let arrayValues = HighReactanceDesign.arrayStringValues()
            let index = arrayValues.index(of: self.rawValue)
            return index
        }
    }
    
    fileprivate typealias `Self` = ElectricArcFurnaceData
    
    static let HELP_PDF_URL = Bundle.main.path(forResource: "Help_Arc_Furnace", ofType: "pdf")!
    static let HELP_TITLE = "Electric Arc Furnace Help"
    
    static let THREE_PHASE_SHORT_CIRCUIT_STRENGTH_AT_PCC = "3-Ph Short Circuit Stength at PCC"
    static let FURNACE_SIZE = "Furnace Size (MW)"
    
    static let HIGH_REACTANCE_DESIGN = "High Reactance Design"
    static let HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR = "High Reactance Design Correction Factor"
    
    static let FURNACE_TYPE = "Furnace Type"
    static let FURNACE_TYPE_CORRECTION_FACTOR = "Furnace Type Correction Factor"
    
    static let COMPENSATION = "Compensation"
    static let COMPENSATION_CORRECTION_FACTOR = "Compensation Correction Factor"
    
    static let LAMP_BASE_VOLTAGE = "Lamp Base Voltage"
    static let LAMP_BASE_VOLTAGE_CORRECTION_FACTOR = "Lamp Base Voltage Correction Factor"
    
    static let flickerSeverityFactorLower : Double = 58.0
    static let flickerSeverityFactorHigher : Double = 70.0
    
    fileprivate(set) var pstDueToLoadAtPCCLower : Double?
    fileprivate(set) var pstDueToLoadAtPCCHigher : Double?
    fileprivate(set) var overallPstAtPCCLower : Double?
    fileprivate(set) var overallPstAtPCCHigher : Double?
    fileprivate(set) var overallPstAtUSBusLower : Double?
    fileprivate(set) var overallPstAtUSBusHigher : Double?
    fileprivate(set) var maxSizePstDueToLoadAtPCC : Double?
    fileprivate(set) var maxSizeOverallPstAtPCC : Double?
    
    fileprivate var _threePhaseShortCircuitStrenghAtPCC : Double?
    var threePhaseShortCircuitStrenghAtPCC : Double? {
        set {
            if newValue != _threePhaseShortCircuitStrenghAtPCC {
                _threePhaseShortCircuitStrenghAtPCC = newValue
                
                Self.saveObjectToNSUserDefaults(Self.THREE_PHASE_SHORT_CIRCUIT_STRENGTH_AT_PCC, value: self.threePhaseShortCircuitStrenghAtPCC as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _threePhaseShortCircuitStrenghAtPCC }
    }
    
    fileprivate var _furnaceSize : Double?
    var furnaceSize : Double? {
        set {
            if newValue != _furnaceSize {
                _furnaceSize = newValue
                
                Self.saveObjectToNSUserDefaults(Self.FURNACE_SIZE, value: self.furnaceSize as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _furnaceSize }
    }
    
    fileprivate var _highReactanceDesign : HighReactanceDesign?
    var highReactanceDesign : HighReactanceDesign? {
        set {
            if newValue != _highReactanceDesign {
                _highReactanceDesign = newValue
                
                self.highReactanceDesignCorrectionFactor = self.highReactanceDesign?.correctionFactor().lower
                
                Self.saveHighReactanceDesign(self.highReactanceDesign)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _highReactanceDesign }
    }
    
    fileprivate var _highReactanceDesignCorrectionFactor : Double?
    var highReactanceDesignCorrectionFactor : Double? {
        set {
            if newValue != _highReactanceDesignCorrectionFactor {
                _highReactanceDesignCorrectionFactor = newValue
                
                Self.saveObjectToNSUserDefaults(Self.HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR, value: self.highReactanceDesignCorrectionFactor as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _highReactanceDesignCorrectionFactor }
    }
    
    fileprivate var _furnaceType : FurnaceType?
    var furnaceType : FurnaceType? {
        set {
            if newValue != _furnaceType {
                _furnaceType = newValue
                
                self.furnaceTypeCorrectionFactor = self.furnaceType?.correctionFactor().lower
                
                Self.saveFurnaceType(self.furnaceType)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _furnaceType }
    }
    
    fileprivate var _furnaceTypeCorrectionFactor : Double?
    var furnaceTypeCorrectionFactor : Double? {
        set {
            if newValue != _furnaceTypeCorrectionFactor {
                _furnaceTypeCorrectionFactor = newValue
                
                Self.saveObjectToNSUserDefaults(Self.FURNACE_TYPE_CORRECTION_FACTOR, value: self.furnaceTypeCorrectionFactor as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _furnaceTypeCorrectionFactor }
    }
    
    fileprivate var _compensation : Compensation?
    var compensation : Compensation? {
        set {
            if newValue != _compensation {
                _compensation = newValue
                
                self.compensationCorrectionFactor = self.compensation?.correctionFactor().lower
                
                Self.saveCompensation(self.compensation)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _compensation }
    }
    
    fileprivate var _compensationCorrectionFactor : Double?
    var compensationCorrectionFactor : Double? {
        set {
            if newValue != _compensationCorrectionFactor {
                _compensationCorrectionFactor = newValue
                
                Self.saveObjectToNSUserDefaults(Self.COMPENSATION_CORRECTION_FACTOR, value: self.compensationCorrectionFactor as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _compensationCorrectionFactor }
    }
    
    fileprivate var _lampBaseVoltage : LampBaseVoltage?
    var lampBaseVoltage : LampBaseVoltage? {
        set {
            if newValue != _lampBaseVoltage {
                _lampBaseVoltage = newValue
                
                self.lampBaseVoltageCorrectionFactor = self.lampBaseVoltage?.correctionFactor().lower
                
                Self.saveLampBaseVoltage(self.lampBaseVoltage)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _lampBaseVoltage }
    }
    
    fileprivate var _lampBaseVoltageCorrectionFactor : Double?
    var lampBaseVoltageCorrectionFactor : Double? {
        set {
            if newValue != _lampBaseVoltageCorrectionFactor {
                _lampBaseVoltageCorrectionFactor = newValue
                
                Self.saveObjectToNSUserDefaults(Self.LAMP_BASE_VOLTAGE_CORRECTION_FACTOR, value: self.lampBaseVoltageCorrectionFactor as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _lampBaseVoltageCorrectionFactor }
    }
    
    // MARK: - Delegates
    var delegates = [ElectricArcFurnaceProtocol]()
    
    // MARK: - Singleton Constructor
    static let sharedInstance = ElectricArcFurnaceData()
    
    // MARK: - Constructor
    override init() {
        super.init()
        
        self.setDefaultValuesIfNil()
        
        FlickerLimits.sharedInstance.delegates.append(self)
        
        self.loadFromNSUserDefaults()
        
        self.recalculateOutputParameters()
    }
    
    // MARK: - Resetting
    func reset() {

        Self.saveObjectToNSUserDefaults(Self.THREE_PHASE_SHORT_CIRCUIT_STRENGTH_AT_PCC, value: nil)
        Self.saveObjectToNSUserDefaults(Self.FURNACE_SIZE, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.HIGH_REACTANCE_DESIGN, value: nil)
        Self.saveObjectToNSUserDefaults(Self.HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.FURNACE_TYPE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.FURNACE_TYPE_CORRECTION_FACTOR, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.COMPENSATION, value: nil)
        Self.saveObjectToNSUserDefaults(Self.COMPENSATION_CORRECTION_FACTOR, value: nil)
        
        Self.saveObjectToNSUserDefaults(Self.LAMP_BASE_VOLTAGE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.LAMP_BASE_VOLTAGE_CORRECTION_FACTOR, value: nil)
        
        self.setDefaultValuesIfNil()
        
        self.loadFromNSUserDefaults()
        
        for delegate in self.delegates {
            delegate.electricArcFurnaceDataDidReset()
        }
    }
    
    // MARK: Default Values
    fileprivate func setDefaultValuesIfNil() {
        let highReactanceDesign: HighReactanceDesign? = Self.loadHighReactanceDesign()
        let defaultHighReactanceDesign = HighReactanceDesign.No
        if highReactanceDesign == nil {
            Self.saveHighReactanceDesign(defaultHighReactanceDesign)
        }
        
        let highReactanceDesignCorrectionFactor : Double? = Self.loadObjectFromNSUserDefaults(Self.HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR)
        if highReactanceDesignCorrectionFactor == nil {
            Self.saveObjectToNSUserDefaults(Self.HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR, value: defaultHighReactanceDesign.correctionFactor().lower as AnyObject?)
        }
        
        let furnaceType: FurnaceType? = Self.loadFurnaceType()
        let defaultFurnaceType = FurnaceType.AC
        if furnaceType == nil {
            Self.saveFurnaceType(defaultFurnaceType)
        }
        
        let furnaceTypeCorrectionFactor : Double? = Self.loadObjectFromNSUserDefaults(Self.FURNACE_TYPE_CORRECTION_FACTOR)
        if furnaceTypeCorrectionFactor == nil {
            Self.saveObjectToNSUserDefaults(Self.FURNACE_TYPE_CORRECTION_FACTOR, value: defaultFurnaceType.correctionFactor().lower as AnyObject?)
        }
        
        let compensation: Compensation? = Self.loadCompensation()
        let defaultCompensation = Compensation.None
        if compensation == nil {
            Self.saveCompensation(defaultCompensation)
        }
        
        let compensationCorrectionFactor : Double? = Self.loadObjectFromNSUserDefaults(Self.COMPENSATION_CORRECTION_FACTOR)
        if compensationCorrectionFactor == nil {
            Self.saveObjectToNSUserDefaults(Self.COMPENSATION_CORRECTION_FACTOR, value: defaultCompensation.correctionFactor().lower as AnyObject?)
        }
        
        let lampBaseVoltage: LampBaseVoltage? = Self.loadLampBaseVoltage()
        let defaultLampBaseVoltage = LampBaseVoltage.TwoHundredAndThirtyVolts
        if lampBaseVoltage == nil {
            Self.saveLampBaseVoltage(defaultLampBaseVoltage)
        }
        
        let lampBaseVoltageCorrectionFactor : Double? = Self.loadObjectFromNSUserDefaults(Self.LAMP_BASE_VOLTAGE_CORRECTION_FACTOR)
        if lampBaseVoltageCorrectionFactor == nil {
            Self.saveObjectToNSUserDefaults(Self.LAMP_BASE_VOLTAGE_CORRECTION_FACTOR, value: defaultLampBaseVoltage.correctionFactor().lower as AnyObject?)
        }
    }
    
    // MARK: - Error Reporting
    func missingInputsString(_ seperator: String?) -> String {
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
        
        if self.threePhaseShortCircuitStrenghAtPCC == nil {
            missing.append(Self.THREE_PHASE_SHORT_CIRCUIT_STRENGTH_AT_PCC)
        }
        if self.furnaceSize == nil  {
            missing.append(Self.FURNACE_SIZE)
        }
        if self.highReactanceDesign == nil {
            missing.append(Self.HIGH_REACTANCE_DESIGN)
        }
        if self.furnaceType == nil {
            missing.append(Self.FURNACE_TYPE)
        }
        if self.compensation == nil {
            missing.append(Self.COMPENSATION)
        }
        if self.lampBaseVoltage == nil {
            missing.append(Self.LAMP_BASE_VOLTAGE)
        }
        
        return missing
    }
    
    // MARK: Within Limits
    func withinLimits() -> Bool {
        
        var valid = false
        
        if self.pstDueToLoadAtPCCLowerValid() &&
            self.pstDueToLoadAtPCCHigherValid() &&
            self.overallPstAtPCCLowerValid() &&
            self.overallPstAtPCCHigherValid() {
            
            valid = true
            
        }
        
        return valid
    }
    
    func pstDueToLoadAtPCCLowerValid() -> Bool {
        
        var valid = false
        
        if let emissionLimit = FlickerLimits.sharedInstance.emissionLimit,
            let pstDueToLoadAtPCCLower = self.pstDueToLoadAtPCCLower {
            
            if pstDueToLoadAtPCCLower.roundToPlaces(2) <= emissionLimit.roundToPlaces(2) {
                valid = true
            }
            
        }
        
        return valid
    }
    
    func pstDueToLoadAtPCCHigherValid() -> Bool {
        
        var valid = false
        
        if let emissionLimit = FlickerLimits.sharedInstance.emissionLimit,
            let pstDueToLoadAtPCCHigher = self.pstDueToLoadAtPCCHigher {
            
            if pstDueToLoadAtPCCHigher.roundToPlaces(2) <= emissionLimit.roundToPlaces(2) {
                valid = true
            }
            
        }
        
        return valid
        
    }
    
    func overallPstAtPCCLowerValid() -> Bool {
        
        var valid = false
        
        if let maximumGlobalContributionAtPCC = FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC,
            let overallPstAtPCCLower = self.overallPstAtPCCLower {
            
            if overallPstAtPCCLower.roundToPlaces(2) <= maximumGlobalContributionAtPCC.roundToPlaces(2) {
                valid = true
            }
            
        }
        
        return valid
        
    }
    
    func overallPstAtPCCHigherValid() -> Bool {
        
        var valid = false
        
        if let maximumGlobalContributionAtPCC = FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC,
            let overallPstAtPCCHigher = self.overallPstAtPCCHigher {
            
            if overallPstAtPCCHigher.roundToPlaces(2) <= maximumGlobalContributionAtPCC.roundToPlaces(2) {
                valid = true
            }
            
        }
        
        return valid
        
    }
    
    // MARK: - NSUserDefault Interface
    // MARK: Custom Type Saves
    fileprivate static func saveFurnaceType(_ furnaceType: FurnaceType?) {
        Self.saveObjectToNSUserDefaults(Self.FURNACE_TYPE, value: furnaceType?.rawValue as AnyObject?)
    }
    
    fileprivate static func saveHighReactanceDesign(_ highReactanceDesign: HighReactanceDesign?) {
        Self.saveObjectToNSUserDefaults(Self.HIGH_REACTANCE_DESIGN, value: highReactanceDesign?.rawValue as AnyObject?)
    }
    
    fileprivate static func saveCompensation(_ compensation: Compensation?) {
        Self.saveObjectToNSUserDefaults(Self.COMPENSATION, value: compensation?.rawValue as AnyObject?)
    }
    
    fileprivate static func saveLampBaseVoltage(_ lampBaseVoltage: LampBaseVoltage?) {
        Self.saveObjectToNSUserDefaults(Self.LAMP_BASE_VOLTAGE, value: lampBaseVoltage?.rawValue as AnyObject?)
    }
    
    // MARK: Custom Type Loaders
    fileprivate static func loadFurnaceType() -> FurnaceType? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.FURNACE_TYPE),
            let furnaceType = FurnaceType.init(rawValue: stringValue!) {
            return furnaceType
        } else {
            return nil
        }
    }
    
    fileprivate static func loadHighReactanceDesign() -> HighReactanceDesign? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.HIGH_REACTANCE_DESIGN),
            let highReactanceDesign = HighReactanceDesign.init(rawValue: stringValue!) {
            return highReactanceDesign
        } else {
            return nil
        }
    }
    
    fileprivate static func loadCompensation() -> Compensation? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.COMPENSATION),
            let compensation = Compensation.init(rawValue: stringValue!) {
            return compensation
        } else {
            return nil
        }
    }
    
    fileprivate static func loadLampBaseVoltage() -> LampBaseVoltage? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.LAMP_BASE_VOLTAGE),
            let lampBaseVoltage = LampBaseVoltage.init(rawValue: stringValue!) {
            return lampBaseVoltage
        } else {
            return nil
        }
    }
    
    // MARK: Load
    func loadFromNSUserDefaults() {
        _threePhaseShortCircuitStrenghAtPCC = Self.loadObjectFromNSUserDefaults(Self.THREE_PHASE_SHORT_CIRCUIT_STRENGTH_AT_PCC)
        _furnaceSize = Self.loadObjectFromNSUserDefaults(Self.FURNACE_SIZE)
        
        
        _highReactanceDesign = Self.loadHighReactanceDesign()
        _highReactanceDesignCorrectionFactor = Self.loadObjectFromNSUserDefaults(Self.HIGH_REACTANCE_DESIGN_CORRECTION_FACTOR)
        
        _furnaceType = Self.loadFurnaceType()
        _furnaceTypeCorrectionFactor = Self.loadObjectFromNSUserDefaults(Self.FURNACE_TYPE_CORRECTION_FACTOR)
        
        _compensation = Self.loadCompensation()
        _compensationCorrectionFactor = Self.loadObjectFromNSUserDefaults(Self.COMPENSATION_CORRECTION_FACTOR)
        
        _lampBaseVoltage = Self.loadLampBaseVoltage()
        _lampBaseVoltageCorrectionFactor = Self.loadObjectFromNSUserDefaults(Self.LAMP_BASE_VOLTAGE_CORRECTION_FACTOR)
    }
    
    // MARK: - Formatted Output Strings
    static func formattedDoubleValue(_ value: Double?, emptyValue: String = "") -> String {
        if let value = value {
            return String.init(format: "%.2f", value)
        } else {
            return emptyValue
        }
    }
    
    // MARK: - Outputs
    
    fileprivate func recalculateOutputParameters(_ notiftyDelegates: Bool = true) {
        
        if let furnaceSize = self.furnaceSize,
            let threePhaseShortCircuitStrenghAtPCC = self.threePhaseShortCircuitStrenghAtPCC,
            let highReactanceDesignCorrectionFactor = self.highReactanceDesignCorrectionFactor,
            let furnaceTypeCorrectionFactor = self.furnaceTypeCorrectionFactor,
            let compensationCorrectionFactor = self.compensationCorrectionFactor,
            let lampBaseVoltageCorrectionFactor = self.lampBaseVoltageCorrectionFactor {
            
            self.pstDueToLoadAtPCCLower = Self.calculatePstDueToLoadAtPCCLower(Self.flickerSeverityFactorLower,
                                                                               furnaceSize: furnaceSize,
                                                                               threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrenghAtPCC,
                                                                               highReactanceDesignCorrectionFactor: highReactanceDesignCorrectionFactor,
                                                                               furnaceTypeCorrectionFactor: furnaceTypeCorrectionFactor,
                                                                               compensationCorrectionFactor: compensationCorrectionFactor,
                                                                               lampBaseVoltageCorrectionFactor: lampBaseVoltageCorrectionFactor)
            
        } else {
            self.pstDueToLoadAtPCCLower = nil
        }
        
        if let furnaceSize = self.furnaceSize,
            let threePhaseShortCircuitStrenghAtPCC = self.threePhaseShortCircuitStrenghAtPCC,
            let highReactanceDesignCorrectionFactor = self.highReactanceDesignCorrectionFactor,
            let furnaceTypeCorrectionFactor = self.furnaceTypeCorrectionFactor,
            let compensationCorrectionFactor = self.compensationCorrectionFactor,
            let lampBaseVoltageCorrectionFactor = self.lampBaseVoltageCorrectionFactor {
            
            self.pstDueToLoadAtPCCHigher = Self.calculatePstDueToLoadAtPCCHigher(Self.flickerSeverityFactorHigher,
                                                                                 furnaceSize: furnaceSize,
                                                                                 threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrenghAtPCC,
                                                                                 highReactanceDesignCorrectionFactor: highReactanceDesignCorrectionFactor,
                                                                                 furnaceTypeCorrectionFactor: furnaceTypeCorrectionFactor,
                                                                                 compensationCorrectionFactor: compensationCorrectionFactor,
                                                                                 lampBaseVoltageCorrectionFactor: lampBaseVoltageCorrectionFactor)
            
        } else {
            self.pstDueToLoadAtPCCHigher = nil
        }
        
        if let backgroundFlicker = FlickerLimits.sharedInstance.backgroundFlicker,
            let summationLawExponent = FlickerLimits.sharedInstance.summationLawExponent,
            let pstDueToLoadAtPCCLower = self.pstDueToLoadAtPCCLower {
            
            self.overallPstAtPCCLower = Self.calculateOverallPstAtPCCLower(backgroundFlicker,
                                                                           summationLawExponent: summationLawExponent,
                                                                           pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
            
        } else {
            self.overallPstAtPCCLower = nil
        }
        
        if let backgroundFlicker = FlickerLimits.sharedInstance.backgroundFlicker,
            let summationLawExponent = FlickerLimits.sharedInstance.summationLawExponent,
            let pstDueToLoatAtPCCHigher = self.pstDueToLoadAtPCCHigher {
            
            self.overallPstAtPCCHigher = Self.calculateOverallPstAtPCCHigher(backgroundFlicker,
                                                                             summationLawExponent: summationLawExponent,
                                                                             pstDueToLoadAtPCCHigher: pstDueToLoatAtPCCHigher)
            
        } else {
            self.overallPstAtPCCHigher = nil
        }
        
        if let overallPstAtPCCLower = self.overallPstAtPCCLower,
            let pccToUpstreamSystemTransferCoefficient = FlickerLimits.sharedInstance.pccToUpstreamSystemTransferCoefficient {
            
            self.overallPstAtUSBusLower = Self.calculateOverallPstAtUSBusLower(overallPstAtPCCLower,
                                                                               pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
            
        } else {
            self.overallPstAtUSBusLower = nil
        }
        
        if let overallPstAtPCCHigher = self.overallPstAtPCCHigher,
            let pccToUpstreamSystemTransferCoefficient = FlickerLimits.sharedInstance.pccToUpstreamSystemTransferCoefficient {
        
            self.overallPstAtUSBusHigher = Self.calculateOverallPstAtUSBusHigher(overallPstAtPCCHigher,
                                                                                 pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        } else {
            self.overallPstAtUSBusHigher = nil
        }
        
        
        if let emissionLimit = FlickerLimits.sharedInstance.emissionLimit,
            let furnaceSize = self.furnaceSize,
            let pstDueToLoadAtPCCLower = self.pstDueToLoadAtPCCLower {
            
            self.maxSizePstDueToLoadAtPCC = Self.calculateMaxSizePstDueToLoadAtPCC(emissionLimit,
                                                                                   furnaceSize: furnaceSize,
                                                                                   pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)

            
        } else {
            self.maxSizePstDueToLoadAtPCC = nil
        }
        
        if let maximumGlobalContributionAtPCC = FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC,
            let furnaceSize = self.furnaceSize,
            let overallPstAtPCCLower = self.overallPstAtPCCLower {
            
            self.maxSizeOverallPstAtPCC = Self.calculateMaxSizeOverallPstAtPCC(maximumGlobalContributionAtPCC,
                                                                               furnaceSize: furnaceSize,
                                                                               overallPstAtPCCLower: overallPstAtPCCLower)
            
        } else {
            self.maxSizeOverallPstAtPCC = nil
        }
        
        if notiftyDelegates {
            self.notifyDelegatesOfElectricArcFurnaceChanges()
        }
    }
    
    fileprivate func notifyDelegatesOfElectricArcFurnaceChanges() {
        for delegate in self.delegates {
            delegate.electricArcFurnaceDataDidChange()
        }
    }
    
    internal static func calculatePstDueToLoadAtPCCLower(_ flickerSeverityFactorLower: Double,
                                                         furnaceSize: Double,
                                                         threePhaseShortCircuitStrengthAtPCC: Double,
                                                         highReactanceDesignCorrectionFactor: Double,
                                                         furnaceTypeCorrectionFactor: Double,
                                                         compensationCorrectionFactor: Double,
                                                         lampBaseVoltageCorrectionFactor: Double) -> Double {
    
        let fraction = furnaceSize / threePhaseShortCircuitStrengthAtPCC
        let cfComponents = highReactanceDesignCorrectionFactor * furnaceTypeCorrectionFactor * compensationCorrectionFactor * lampBaseVoltageCorrectionFactor
        
        let pstDueToLoadAtPCCLower = flickerSeverityFactorLower * 2.0 * fraction * cfComponents
        
        return pstDueToLoadAtPCCLower
    }
    
    internal static func calculatePstDueToLoadAtPCCHigher(_ flickerSeverityFactorHigher: Double,
                                                          furnaceSize: Double,
                                                          threePhaseShortCircuitStrengthAtPCC: Double,
                                                          highReactanceDesignCorrectionFactor: Double,
                                                          furnaceTypeCorrectionFactor: Double,
                                                          compensationCorrectionFactor: Double,
                                                          lampBaseVoltageCorrectionFactor: Double) -> Double {
        
        let fraction = furnaceSize / threePhaseShortCircuitStrengthAtPCC
        let cfComponents = highReactanceDesignCorrectionFactor * furnaceTypeCorrectionFactor * compensationCorrectionFactor * lampBaseVoltageCorrectionFactor
        
        let pstDueToLoadAtPCCHigher = flickerSeverityFactorHigher * 2.0 * fraction * cfComponents
        
        return pstDueToLoadAtPCCHigher
    }
    
    internal static func calculateOverallPstAtPCCLower(_ backgroundFlicker: Double,
                                                       summationLawExponent: Double,
                                                       pstDueToLoadAtPCCLower: Double) -> Double {
        
        let inside = pow(backgroundFlicker, summationLawExponent) + pow(pstDueToLoadAtPCCLower, summationLawExponent)
        let overallPstAtPCCLower = pow(inside, (1.0 / summationLawExponent))
        return overallPstAtPCCLower
    }
    
    internal static func calculateOverallPstAtPCCHigher(_ backgroundFlicker: Double,
                                                        summationLawExponent: Double,
                                                        pstDueToLoadAtPCCHigher: Double) -> Double {
        
        let inside = pow(backgroundFlicker, summationLawExponent) + pow(pstDueToLoadAtPCCHigher, summationLawExponent)
        let overallPstAtPCCHigher = pow(inside, (1.0 / summationLawExponent))
        return overallPstAtPCCHigher
    }
    
    internal static func calculateOverallPstAtUSBusLower(_ overallPstAtPCCLower: Double,
                                                         pccToUpstreamSystemTransferCoefficient: Double) -> Double {
        
        let overallPstAtUSBusLower = overallPstAtPCCLower * pccToUpstreamSystemTransferCoefficient
        return overallPstAtUSBusLower
    }
    
    internal static func calculateOverallPstAtUSBusHigher(_ overallPstAtPCCHigher: Double,
                                                          pccToUpstreamSystemTransferCoefficient: Double) -> Double {
        
        let overallPstAtUSBusHigher = overallPstAtPCCHigher * pccToUpstreamSystemTransferCoefficient
        return overallPstAtUSBusHigher
    }
    
    internal static func calculateMaxSizePstDueToLoadAtPCC(_ emissionLimit: Double,
                                                           furnaceSize: Double,
                                                           pstDueToLoadAtPCCLower: Double) -> Double {
        
        let product = furnaceSize * emissionLimit
        let maxSizeOverallPstAtPCC = product / pstDueToLoadAtPCCLower
        return maxSizeOverallPstAtPCC
    }
    
    internal static func calculateMaxSizeOverallPstAtPCC(_ maximumGlobalContributionAtPCC: Double,
                                                         furnaceSize: Double,
                                                         overallPstAtPCCLower: Double) -> Double {
        
        let product = furnaceSize * maximumGlobalContributionAtPCC
        let maxSizePstDueToLoadAtPCC = product / overallPstAtPCCLower
        return maxSizePstDueToLoadAtPCC
    }
}

// MARK: - FlickerLimitProtocol
extension ElectricArcFurnaceData : FlickerLimitProtocol {
    func flickerLimitsDidChange() {
        self.recalculateOutputParameters()
    }
    
    func flickerLimitsDidReset() {
        self.recalculateOutputParameters()
    }
}
