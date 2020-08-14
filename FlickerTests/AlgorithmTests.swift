//
//  AlgorithmTests.swift
//  Flicker
//
//  Created by Anders Melen on 5/25/16.
//  Copyright © 2016 epri. All rights reserved.
//

import XCTest

class AlgorithmTests: XCTestCase {
    
    typealias FlickerLimitsResult = (maximumGlobalContribution: Double, emisisonLimit: Double)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: - Test Case One - Repetitive Load
    
    // This case deals with estimating flicker due to the operation of a rolling mill whose load profile is known.
    // A rolling mill example is presented here from IEC Standard 61000-3-7.
    // The expected voltage profile at the PCC due to the operation of the mill is shown in Figure 2-1 .
    
    func testCaseOne_FlickerLimits_Result() -> FlickerLimitsResult {
        
//        let upstreamSystemRatedVoltage = 69.0
//        let pccRatedVoltage = 4.16
//        let backgroundFlicker = 0.5
        
        let upstreamPlanningLevel = 0.8
        let upstreamSystemToPCCTransferCoefficient = 0.9
//        let pccToUpstreamSystemTransferCoefficient = 0.9
        let pccPlanningLevel = 0.9
        let summationLawExponent = 3.0
        let sizeOfPCCUnderLoad = 3.0
        let totalCapacityOfSystemAtPCCAndLCInMVA = 20.0
        let totalPowerOfLoadInLVSystemInMVA = 0.0

        
        let maximumGlobalContribution = FlickerLimits.calcuateMaximumGlobalContributionAtPCC(pccPlanningLevel,
                                                                                             upstreamSystemToPCCTransferCoefficient: upstreamSystemToPCCTransferCoefficient,
                                                                                             upstreamPlanningLevel: upstreamPlanningLevel,
                                                                                             summationLawExponent: summationLawExponent)
        
        let emissionLimit = FlickerLimits.calculateEmissionLimit(sizeOfPCCUnderLoad,
                                                                 totalCapacityOfSystemAtPCCAndLCInMVA: totalCapacityOfSystemAtPCCAndLCInMVA,
                                                                 totalPowerOfLoadInLVSystemInMVA: totalPowerOfLoadInLVSystemInMVA,
                                                                 summationLawExponent: summationLawExponent,
                                                                 maximumGlobalContributionAtPCC: maximumGlobalContribution)
        
        return FlickerLimitsResult(maximumGlobalContribution, emissionLimit)
    }
    
    func testCaseOne_FlickerLimits() {
        
        let result = testCaseOne_FlickerLimits_Result()
        let maximumGlobalContribution = result.maximumGlobalContribution
        let emissionLimit = result.emisisonLimit
        
        let expectedMaximumGlobalContribution = 0.71
        let expectedEmissionLimit = 0.38
        
        XCTAssert(maximumGlobalContribution.roundToPlaces(2) == expectedMaximumGlobalContribution, "Incorrect Maximum Global Contribution. Expected \(expectedMaximumGlobalContribution) but found \(maximumGlobalContribution.roundToPlaces(2))")
        XCTAssert(emissionLimit.roundToPlaces(2) == expectedEmissionLimit, "Incorrect Emission Limit. Expected \(expectedEmissionLimit) but found \(emissionLimit.roundToPlaces(2))")
        
    }
    
    // Based on system details and loading information at the PCC,
    // the module has computed for the rolling mill load an emission limit of 0.38 for Pst.
    // This load falls in the category of “Repetitive Loads,”
    // so the next section presents the various fields and computed values under “Estimating Flicker – Repetitive Load” Tab.
    
    // It may be noted that flicker estimated due to load at the PCC is below the emission limit determined in the previous section,
    // so no mitigation step is required. Also, overall flicker value is much lower than the recommended planning level meaning,
    // there is some margin to add additional flicker-causing loads at the PCC.
    // The Max Current level indicates the amount of load current that would be allowed without exceeding the indicated flicker limits.
    
    func testCaseOne_RepetitiveLoadOne() {
        
        let shapeType = RepetitiveLoadData.ShapeType.DoubleRamp
        let changeUnit = RepetitiveLoadData.ChangeUnit.Minute
        let changeRate = 6.0
        let deltaVVPercentAtPCC = 2.0
        let durationOfVoltageChange = 500.0
        let loadAmpsResultingInDeltaVVAtPCC = 100.0
        
        
        let backgroundFlicker = 0.5
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseOne_FlickerLimits_Result()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let expectedDeltaVVAtPCC = 1.797 // DPST_1
        let expectedShapeFactor = 0.3
        
        let expectedFlickerDueToLoadAtPCCPst = 0.33
        let expectedFlickerDueToLoadAtPCCMaxCurrent = 113.81
        
        let expectedOverallFlickerAtPCCPst = 0.55
        let expectedOverallFlickerAtPCCMaxCurrent = 130.18
        
        let expectedOverallFlickerAtUSBus = 0.49
        
        
        let deltaVVAtPCC = RepetitiveLoadData.calculateDPstOne(changeRate,
                                                               changeUnit: changeUnit)

        
        XCTAssertNotNil(deltaVVAtPCC, "Found nil when calculating Delta VV At PCC (AKA DPST_1)!")
        
        let shapeFactor = RepetitiveLoadData.calculateShapeFactor(shapeType,
                                                                  durationOfVoltageChange: durationOfVoltageChange,
                                                                  changeRate: changeRate,
                                                                  changeUnit: changeUnit)
        
        XCTAssertNotNil(shapeFactor, "Found nil when calculating Shape Factor!")
        
        let flickerDueToLoadAtPCCPst = RepetitiveLoadData.calculateFlickerDueToLoadAtPCCPstForNonAperiodic(deltaVVAtPCC!,
                                                                                                           shapeFactor: shapeFactor!,
                                                                                                           deltaVVAtPCC: deltaVVPercentAtPCC)
        let flickerDueToLoadAtPCCMaxCurrent = RepetitiveLoadData.calculateFlickerDueToLoadAtPCCMaxCurrent(emissionLimit.roundToPlaces(2),
                                                                                                          flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                                          loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVAtPCC)
        
        let overallFlickerAtPCCPst = RepetitiveLoadData.calculateOverallFlickerAtPCCPst(backgroundFlicker,
                                                                                        flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                        summationLawExponent: summationLawExponent)
        let overallFlickeratPCCMaxCurrent = RepetitiveLoadData.calculateOverallFlickerAtPCCMaxCurrent(maximumGlobalContribution.roundToPlaces(2),
                                                                                                      overallFlickerAtPCCPst: overallFlickerAtPCCPst,
                                                                                                      loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVAtPCC)
        
        let overallFlickerAtUSBus = RepetitiveLoadData.calculateOverallFlickerAtUSBusPst(overallFlickerAtPCCPst,
                                                                                         pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        XCTAssert(deltaVVAtPCC!.roundToPlaces(3) == expectedDeltaVVAtPCC, "Incorrect Delta VV At PCC (AKA DPST_1). Expected \(expectedDeltaVVAtPCC) but found \(deltaVVAtPCC!.roundToPlaces(3))")
        XCTAssert(shapeFactor!.roundToPlaces(2) == expectedShapeFactor, "Incorrect Shape Factor. Expected \(expectedShapeFactor) but found \(shapeFactor!.roundToPlaces(2))")
        
        
        
        XCTAssert(flickerDueToLoadAtPCCPst.roundToPlaces(2) == expectedFlickerDueToLoadAtPCCPst, "Incorrect Flicker Due To Load At PCC Pst. Expected \(expectedFlickerDueToLoadAtPCCPst) but found \(flickerDueToLoadAtPCCPst.roundToPlaces(2))")
        XCTAssert(flickerDueToLoadAtPCCMaxCurrent.roundToPlaces(2) == expectedFlickerDueToLoadAtPCCMaxCurrent, "Incorrect Flicker Due To Load At PCC Max Current. Expected \(expectedFlickerDueToLoadAtPCCMaxCurrent) but found \(flickerDueToLoadAtPCCMaxCurrent.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtPCCPst.roundToPlaces(2) == expectedOverallFlickerAtPCCPst, "Incorrect Overall Flicker At PCC Pst. Expected \(expectedOverallFlickerAtPCCPst) but found \(overallFlickerAtPCCPst.roundToPlaces(2))")
        XCTAssert(overallFlickeratPCCMaxCurrent.roundToPlaces(2) == expectedOverallFlickerAtPCCMaxCurrent, "Incorrect Overall Flicker At PCC Max Current. Expected \(expectedOverallFlickerAtPCCMaxCurrent) but found \(overallFlickeratPCCMaxCurrent.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtUSBus.roundToPlaces(2) == expectedOverallFlickerAtUSBus, "Incorrect Overall Flicker At US Bus. Expected \(expectedOverallFlickerAtUSBus) but found \(overallFlickerAtUSBus.roundToPlaces(2))")
    }
    
    // The flicker estimated due to load at the PCC is above the emission limit, so mitigation steps would be required.
    // Also, overall flicker value is above the recommended planning level, meaning that there would be no margin to add additional flicker causing loads at the PCC.
    // The Max Current levels indicate the amount of load current that would be allowed without exceeding the indicated flicker limits.
    // In this case, without other mitigation, significant current reduction would be required to meet flicker limits.

    func testCaseOne_RepetitiveLoadTwo() {
        
        let shapeType = RepetitiveLoadData.ShapeType.Rectangular
        let changeUnit = RepetitiveLoadData.ChangeUnit.Minute
        let changeRate = 6.0
        let deltaVVPercentAtPCC = 2.0
        let durationOfVoltageChange = 500.0
        let loadAmpsResultingInDeltaVVAtPCC = 100.0
        
        
        let backgroundFlicker = 0.5
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseOne_FlickerLimits_Result()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let expectedDeltaVVAtPCC = 1.797 // DPST_1
        let expectedShapeFactor = 1.0
        
        let expectedFlickerDueToLoadAtPCCPst = 1.11
        let expectedFlickerDueToLoadAtPCCMaxCurrent = 34.14
        
        let expectedOverallFlickerAtPCCPst = 1.15
        let expectedOverallFlickerAtPCCMaxCurrent = 61.97
        
        let expectedOverallFlickerAtUSBus = 1.03
        
        
        let deltaVVAtPCC = RepetitiveLoadData.calculateDPstOne(changeRate,
                                                               changeUnit: changeUnit)
        
        
        XCTAssertNotNil(deltaVVAtPCC, "Found nil when calculating Delta VV At PCC (AKA DPST_1)!")
        
        let shapeFactor = RepetitiveLoadData.calculateShapeFactor(shapeType,
                                                                  durationOfVoltageChange: durationOfVoltageChange,
                                                                  changeRate: changeRate,
                                                                  changeUnit: changeUnit)
        
        XCTAssertNotNil(shapeFactor, "Found nil when calculating Shape Factor!")
        
        let flickerDueToLoadAtPCCPst = RepetitiveLoadData.calculateFlickerDueToLoadAtPCCPstForNonAperiodic(deltaVVAtPCC!,
                                                                                                           shapeFactor: shapeFactor!,
                                                                                                           deltaVVAtPCC: deltaVVPercentAtPCC)
        let flickerDueToLoadAtPCCMaxCurrent = RepetitiveLoadData.calculateFlickerDueToLoadAtPCCMaxCurrent(emissionLimit.roundToPlaces(2),
                                                                                                          flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                                          loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVAtPCC)
        
        let overallFlickerAtPCCPst = RepetitiveLoadData.calculateOverallFlickerAtPCCPst(backgroundFlicker,
                                                                                        flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                        summationLawExponent: summationLawExponent)
        let overallFlickeratPCCMaxCurrent = RepetitiveLoadData.calculateOverallFlickerAtPCCMaxCurrent(maximumGlobalContribution.roundToPlaces(2),
                                                                                                      overallFlickerAtPCCPst: overallFlickerAtPCCPst,
                                                                                                      loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVAtPCC)
        
        let overallFlickerAtUSBus = RepetitiveLoadData.calculateOverallFlickerAtUSBusPst(overallFlickerAtPCCPst,
                                                                                         pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        XCTAssert(deltaVVAtPCC!.roundToPlaces(3) == expectedDeltaVVAtPCC, "Incorrect Delta VV At PCC (AKA DPST_1). Expected \(expectedDeltaVVAtPCC) but found \(deltaVVAtPCC!.roundToPlaces(3))")
        XCTAssert(shapeFactor!.roundToPlaces(2) == expectedShapeFactor, "Incorrect Shape Factor. Expected \(expectedShapeFactor) but found \(shapeFactor!.roundToPlaces(2))")
        
        
        
        XCTAssert(flickerDueToLoadAtPCCPst.roundToPlaces(2) == expectedFlickerDueToLoadAtPCCPst, "Incorrect Flicker Due To Load At PCC Pst. Expected \(expectedFlickerDueToLoadAtPCCPst) but found \(flickerDueToLoadAtPCCPst.roundToPlaces(2))")
        XCTAssert(flickerDueToLoadAtPCCMaxCurrent.roundToPlaces(2) == expectedFlickerDueToLoadAtPCCMaxCurrent, "Incorrect Flicker Due To Load At PCC Max Current. Expected \(expectedFlickerDueToLoadAtPCCMaxCurrent) but found \(flickerDueToLoadAtPCCMaxCurrent.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtPCCPst.roundToPlaces(2) == expectedOverallFlickerAtPCCPst, "Incorrect Overall Flicker At PCC Pst. Expected \(expectedOverallFlickerAtPCCPst) but found \(overallFlickerAtPCCPst.roundToPlaces(2))")
        XCTAssert(overallFlickeratPCCMaxCurrent.roundToPlaces(2) == expectedOverallFlickerAtPCCMaxCurrent, "Incorrect Overall Flicker At PCC Max Current. Expected \(expectedOverallFlickerAtPCCMaxCurrent) but found \(overallFlickeratPCCMaxCurrent.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtUSBus.roundToPlaces(2) == expectedOverallFlickerAtUSBus, "Incorrect Overall Flicker At US Bus. Expected \(expectedOverallFlickerAtUSBus) but found \(overallFlickerAtUSBus.roundToPlaces(2))")
    }

    // Random loads (such as motor starts) that may not recur within a specific 10-minute window may be considered aperiodic in nature.
    // The resulting aperiodic voltage changes may be evaluated on a Pst basis.
    // For example, assume that a large motor that was started cross-line takes 10 seconds to start while drawing up to 836 A and then runs in excess of 100 seconds.
    // The voltage drop during starting is 2%. Assuming the same PCC details and allocated flicker emissions limits setting used in the above two examples,
    // we need to determine whether the load exceeds the Flicker due to the load at the PCC and the Overall Flicker at the PCC. To do this,
    // assume all variables are similar to repetitive load 1 except for:
    
    // The flicker estimated due to load at the PCC is above the emission limit, so mitigation steps would be required.
    // However, overall flicker value is below the 0.9 recommended planning level, meaning it may be possible to accept this load,
    // assuming that no additional flicker-causing loads at the PCC or upstream are added.
    // The Max Current levels indicate the amount of load current that would be allowed without exceeding the indicated flicker limits.
    
    // Now, let’s try to mitigate the flicker level. Assume we provide a part-voltage starter that only applies ½ voltage during the starting sequence.
    // Assume this reduces the starting current to 418 A but requires twice as long (20 sec.) to start.
    // The voltage drop during starting is 1%. How will these new parameters effect the flicker at the PCC? To determine this, assume all variables are similar to repetitive load 1 except for:
    
    // While the flicker estimated due to load at the PCC is still slightly above the emission limit due to load at the PCC,
    // the overall flicker at the PCC has now dropped below the 0.71 limit. This solution seems to be a feasible mitigation approach.
    
    func testCaseOne_RepetitiveLoadThree() {
        
        
//        let shapeType = RepetitiveLoadData.ShapeType.Aperiodic
        let deltaVVPercentAtPCC = 2.0
        
        let timeOne = RepetitiveLoadData.TimeOne(rawValue: "10")!
        let timeTwo = RepetitiveLoadData.TimeTwo(rawValue: "100")!
        
        let loadAmpsResultingInDeltaVVAtPCC = 836.0
        
        let backgroundFlicker = 0.5
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseOne_FlickerLimits_Result()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let expectedFlickerDueToLoadAtPCCPst = 0.82
        let expectedFlickerDueToLoadAtPCCMaxCurrent = 389.79
        
        let expectedOverallFlickerAtPCCPst = 0.87
        let expectedOverallFlickerAtPCCMaxCurrent = 679.57
        
        let expectedOverallFlickerAtUSBus = 0.79
        
        

        let flickerDueToLoadAtPCCPst = RepetitiveLoadData.calculateFlickerDueToLoadAtPCCPstForAperiodic(timeOne,
                                                                                                        timeTwo: timeTwo,
                                                                                                        deltaVVAtPCC: deltaVVPercentAtPCC)
        let flickerDueToLoadAtPCCMaxCurrent = RepetitiveLoadData.calculateFlickerDueToLoadAtPCCMaxCurrent(emissionLimit.roundToPlaces(2),
                                                                                                          flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                                          loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVAtPCC)
        
        let overallFlickerAtPCCPst = RepetitiveLoadData.calculateOverallFlickerAtPCCPst(backgroundFlicker,
                                                                                        flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                        summationLawExponent: summationLawExponent)
        let overallFlickeratPCCMaxCurrent = RepetitiveLoadData.calculateOverallFlickerAtPCCMaxCurrent(maximumGlobalContribution.roundToPlaces(2),
                                                                                                      overallFlickerAtPCCPst: overallFlickerAtPCCPst,
                                                                                                      loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVAtPCC)
        
        let overallFlickerAtUSBus = RepetitiveLoadData.calculateOverallFlickerAtUSBusPst(overallFlickerAtPCCPst,
                                                                                         pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        XCTAssert(flickerDueToLoadAtPCCPst.roundToPlaces(2) == expectedFlickerDueToLoadAtPCCPst, "Incorrect Flicker Due To Load At PCC Pst. Expected \(expectedFlickerDueToLoadAtPCCPst) but found \(flickerDueToLoadAtPCCPst.roundToPlaces(2))")
        XCTAssert(flickerDueToLoadAtPCCMaxCurrent.roundToPlaces(2) == expectedFlickerDueToLoadAtPCCMaxCurrent, "Incorrect Flicker Due To Load At PCC Max Current. Expected \(expectedFlickerDueToLoadAtPCCMaxCurrent) but found \(flickerDueToLoadAtPCCMaxCurrent.roundToPlaces(2))")
        
        
        XCTAssert(overallFlickerAtPCCPst.roundToPlaces(2) == expectedOverallFlickerAtPCCPst, "Incorrect Overall Flicker At PCC Pst. Expected \(expectedOverallFlickerAtPCCPst) but found \(overallFlickerAtPCCPst.roundToPlaces(2))")
        XCTAssert(overallFlickeratPCCMaxCurrent.roundToPlaces(2) == expectedOverallFlickerAtPCCMaxCurrent, "Incorrect Overall Flicker At PCC Max Current. Expected \(expectedOverallFlickerAtPCCMaxCurrent) but found \(overallFlickeratPCCMaxCurrent.roundToPlaces(2))")
        
        
        XCTAssert(overallFlickerAtUSBus.roundToPlaces(2) == expectedOverallFlickerAtUSBus, "Incorrect Overall Flicker At US Bus. Expected \(expectedOverallFlickerAtUSBus) but found \(overallFlickerAtUSBus.roundToPlaces(2))")
    }

    
    // MARK: - Test Case Two - Electric Arc Furnace
    func testCaseTwo_FlickerLimits_Results() -> FlickerLimitsResult {
        
        
//        let upstreamSystemRatedVoltage = 345.0
//        let pccRatedVoltage = 138.0
//        let backgroundFlicker = 0.2
        
        let upstreamPlanningLevel = 1.0
        let upstreamSystemToPCCTransferCoefficient = 0.8
//        let pccToUpstreamSystemTransferCoefficient = 0.9
        let pccPlanningLevel = 1.0
        let summationLawExponent = 3.0
        let sizeOfPCCUnderLoad = 200.0
        let totalCapacityOfSystemAtPCCAndLCInMVA = 200.0
        let totalPowerOfLoadInLVSystemInMVA = 0.0
        
        
        let maximumGlobalContribution = FlickerLimits.calcuateMaximumGlobalContributionAtPCC(pccPlanningLevel,
                                                                                             upstreamSystemToPCCTransferCoefficient: upstreamSystemToPCCTransferCoefficient,
                                                                                             upstreamPlanningLevel: upstreamPlanningLevel,
                                                                                             summationLawExponent: summationLawExponent)
        
        let emissionLimit = FlickerLimits.calculateEmissionLimit(sizeOfPCCUnderLoad,
                                                                 totalCapacityOfSystemAtPCCAndLCInMVA: totalCapacityOfSystemAtPCCAndLCInMVA,
                                                                 totalPowerOfLoadInLVSystemInMVA: totalPowerOfLoadInLVSystemInMVA,
                                                                 summationLawExponent: summationLawExponent,
                                                                 maximumGlobalContributionAtPCC: maximumGlobalContribution)
        
        return FlickerLimitsResult(maximumGlobalContribution, emissionLimit)
        
    }
    
    // Based on system details and loading information at the PCC, the module has computed for the
    // electric arc furnace emission limits of 0.79 for both G_Pst and E_Pst. The next section presents
    // the various fields and computed values under “Estimating Flicker – Electric Arc Furnace” tab.
    
    func testCaseTwo_FlickerLimits() {
        
        let result = testCaseTwo_FlickerLimits_Results()
        let maximumGlobalContribution = result.maximumGlobalContribution
        let emissionLimit = result.emisisonLimit
        
        let expectedMaximumGlobalContribution = 0.79
        let expectedEmissionLimit = 0.79
        
        XCTAssert(maximumGlobalContribution.roundToPlaces(2) == expectedMaximumGlobalContribution, "Incorrect Maximum Global Contribution. Expected \(expectedMaximumGlobalContribution) but found \(maximumGlobalContribution.roundToPlaces(2))")
        XCTAssert(emissionLimit.roundToPlaces(2) == expectedEmissionLimit, "Incorrect Emission Limit. Expected \(expectedEmissionLimit) but found \(emissionLimit.roundToPlaces(2))")
        
    }
    
    // Results modified for changes lamp base voltage lower bound correction factor changes from 1.0 to 1.2
    func testCaseTwo_ElectricArcFurnaceOne() {
        
        let backgroundFlicker = 0.2
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseTwo_FlickerLimits_Results()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let threePhaseShortCircuitStrength = 2215.0
        let furnaceSize = 50.0
        let highReactanceDesign = ElectricArcFurnaceData.HighReactanceDesign.No
        let furnaceType = ElectricArcFurnaceData.FurnaceType.AC
        let compensation = ElectricArcFurnaceData.Compensation.None
        let lampBaseVoltage = ElectricArcFurnaceData.LampBaseVoltage.TwoHundredAndThirtyVolts
        let flickerSeverityFactorLower = 58.0
        let flickerSeverityFactorUpper = 70.0
        
        let expectedPstDueToLoadAtPCCLower = 3.14
        let expectedPstDueToLoadAtPCCUpper = 3.79
        let expectedPstDueToLoadMaxSize = 12.57
        
        let expectedOverallPstAtPCCLower = 3.14
        let expectedOverallPstAtPCCUpper = 3.79
        let expectedOverallPstAtPCCMaxSize = 12.57
        
        let expectedOverallFlickerAtUsBusLower = 2.83
        let expectedOverallFlickerAtUsBusUpper = 3.41
        
        
        let pstDueToLoadAtPCCLower = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCLower(flickerSeverityFactorLower,
                                                                                            furnaceSize: furnaceSize,
                                                                                            threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                            highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                            furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                            compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                            lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadAtPCCUpper = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCHigher(flickerSeverityFactorUpper,
                                                                                             furnaceSize: furnaceSize,
                                                                                             threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                             highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                             furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                             compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                             lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadMaxSize = ElectricArcFurnaceData.calculateMaxSizePstDueToLoadAtPCC(emissionLimit.roundToPlaces(2),
                                                                                           furnaceSize: furnaceSize,
                                                                                           pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCLower = ElectricArcFurnaceData.calculateOverallPstAtPCCLower(backgroundFlicker,
                                                                                        summationLawExponent: summationLawExponent,
                                                                                        pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCUpper = ElectricArcFurnaceData.calculateOverallPstAtPCCHigher(backgroundFlicker,
                                                                                         summationLawExponent: summationLawExponent,
                                                                                         pstDueToLoadAtPCCHigher: pstDueToLoadAtPCCUpper)
        
        let overallPstAtPCCMaxSize = ElectricArcFurnaceData.calculateMaxSizeOverallPstAtPCC(maximumGlobalContribution.roundToPlaces(2),
                                                                                            furnaceSize: furnaceSize,
                                                                                            overallPstAtPCCLower: overallPstAtPCCLower)
        
        let overallFlickerAtUSBusLower = ElectricArcFurnaceData.calculateOverallPstAtUSBusLower(overallPstAtPCCLower,
                                                                                                pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        let overallFlickerAtUSBusHigher = ElectricArcFurnaceData.calculateOverallPstAtUSBusHigher(overallPstAtPCCUpper,
                                                                                                  pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
   
        
        XCTAssert(pstDueToLoadAtPCCLower.roundToPlaces(2) == expectedPstDueToLoadAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCLower) but found \(pstDueToLoadAtPCCLower.roundToPlaces(2))")
        XCTAssert(pstDueToLoadAtPCCUpper.roundToPlaces(2) == expectedPstDueToLoadAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCUpper) but found \(pstDueToLoadAtPCCUpper.roundToPlaces(2))")
        XCTAssert(pstDueToLoadMaxSize.roundToPlaces(2) == expectedPstDueToLoadMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadMaxSize) but found \(pstDueToLoadMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallPstAtPCCLower.roundToPlaces(2) == expectedOverallPstAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCLower) but found \(overallPstAtPCCLower.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCUpper.roundToPlaces(2) == expectedOverallPstAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCUpper) but found \(overallPstAtPCCUpper.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCMaxSize.roundToPlaces(2) == expectedOverallPstAtPCCMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCMaxSize) but found \(overallPstAtPCCMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtUSBusLower.roundToPlaces(2) == expectedOverallFlickerAtUsBusLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusLower) but found \(overallFlickerAtUSBusLower.roundToPlaces(2))")
        XCTAssert(overallFlickerAtUSBusHigher.roundToPlaces(2) == expectedOverallFlickerAtUsBusUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusUpper) but found \(overallFlickerAtUSBusHigher.roundToPlaces(2))")
    
    }
    
    // Results modified for changes lamp base voltage lower bound correction factor changes from 1.0 to 1.2
    func testCaseTwo_ElectricArcFurnaceTwo() {
        
        let backgroundFlicker = 0.2
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseTwo_FlickerLimits_Results()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let threePhaseShortCircuitStrength = 2215.0
        let furnaceSize = 50.0
        let highReactanceDesign = ElectricArcFurnaceData.HighReactanceDesign.No
        let furnaceType = ElectricArcFurnaceData.FurnaceType.DC
        let compensation = ElectricArcFurnaceData.Compensation.None
        let lampBaseVoltage = ElectricArcFurnaceData.LampBaseVoltage.TwoHundredAndThirtyVolts
        let flickerSeverityFactorLower = 58.0
        let flickerSeverityFactorUpper = 70.0
        
        let expectedPstDueToLoadAtPCCLower = 1.57
        let expectedPstDueToLoadAtPCCUpper = 1.9
        let expectedPstDueToLoadMaxSize = 25.14
        
        let expectedOverallPstAtPCCLower = 1.57
        let expectedOverallPstAtPCCUpper = 1.9
        let expectedOverallPstAtPCCMaxSize = 25.12
        
        let expectedOverallFlickerAtUsBusLower = 1.41
        let expectedOverallFlickerAtUsBusUpper = 1.71
        
        
        let pstDueToLoadAtPCCLower = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCLower(flickerSeverityFactorLower,
                                                                                            furnaceSize: furnaceSize,
                                                                                            threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                            highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                            furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                            compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                            lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadAtPCCUpper = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCHigher(flickerSeverityFactorUpper,
                                                                                             furnaceSize: furnaceSize,
                                                                                             threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                             highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                             furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                             compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                             lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadMaxSize = ElectricArcFurnaceData.calculateMaxSizePstDueToLoadAtPCC(emissionLimit.roundToPlaces(2),
                                                                                           furnaceSize: furnaceSize,
                                                                                           pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCLower = ElectricArcFurnaceData.calculateOverallPstAtPCCLower(backgroundFlicker,
                                                                                        summationLawExponent: summationLawExponent,
                                                                                        pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCUpper = ElectricArcFurnaceData.calculateOverallPstAtPCCHigher(backgroundFlicker,
                                                                                         summationLawExponent: summationLawExponent,
                                                                                         pstDueToLoadAtPCCHigher: pstDueToLoadAtPCCUpper)
        
        let overallPstAtPCCMaxSize = ElectricArcFurnaceData.calculateMaxSizeOverallPstAtPCC(maximumGlobalContribution.roundToPlaces(2),
                                                                                            furnaceSize: furnaceSize,
                                                                                            overallPstAtPCCLower: overallPstAtPCCLower)
        
        let overallFlickerAtUSBusLower = ElectricArcFurnaceData.calculateOverallPstAtUSBusLower(overallPstAtPCCLower,
                                                                                                pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        let overallFlickerAtUSBusHigher = ElectricArcFurnaceData.calculateOverallPstAtUSBusHigher(overallPstAtPCCUpper,
                                                                                                  pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        
        XCTAssert(pstDueToLoadAtPCCLower.roundToPlaces(2) == expectedPstDueToLoadAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCLower) but found \(pstDueToLoadAtPCCLower.roundToPlaces(2))")
        XCTAssert(pstDueToLoadAtPCCUpper.roundToPlaces(2) == expectedPstDueToLoadAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCUpper) but found \(pstDueToLoadAtPCCUpper.roundToPlaces(2))")
        XCTAssert(pstDueToLoadMaxSize.roundToPlaces(2) == expectedPstDueToLoadMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadMaxSize) but found \(pstDueToLoadMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallPstAtPCCLower.roundToPlaces(2) == expectedOverallPstAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCLower) but found \(overallPstAtPCCLower.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCUpper.roundToPlaces(2) == expectedOverallPstAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCUpper) but found \(overallPstAtPCCUpper.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCMaxSize.roundToPlaces(2) == expectedOverallPstAtPCCMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCMaxSize) but found \(overallPstAtPCCMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtUSBusLower.roundToPlaces(2) == expectedOverallFlickerAtUsBusLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusLower) but found \(overallFlickerAtUSBusLower.roundToPlaces(2))")
        XCTAssert(overallFlickerAtUSBusHigher.roundToPlaces(2) == expectedOverallFlickerAtUsBusUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusUpper) but found \(overallFlickerAtUSBusHigher.roundToPlaces(2))")

        
    }
    
    // Results modified for changes lamp base voltage lower bound correction factor changes from 1.0 to 1.2
    func testCaseTwo_ElectricArcFurnaceThree() {
        
        let backgroundFlicker = 0.2
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseTwo_FlickerLimits_Results()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let threePhaseShortCircuitStrength = 2215.0
        let furnaceSize = 50.0
        let highReactanceDesign = ElectricArcFurnaceData.HighReactanceDesign.No
        let furnaceType = ElectricArcFurnaceData.FurnaceType.AC
        let compensation = ElectricArcFurnaceData.Compensation.SVC
        let lampBaseVoltage = ElectricArcFurnaceData.LampBaseVoltage.TwoHundredAndThirtyVolts
        let flickerSeverityFactorLower = 58.0
        let flickerSeverityFactorUpper = 70.0
        
        let expectedPstDueToLoadAtPCCLower = 1.57
        let expectedPstDueToLoadAtPCCUpper = 1.9
        let expectedPstDueToLoadMaxSize = 25.14
        
        let expectedOverallPstAtPCCLower = 1.57
        let expectedOverallPstAtPCCUpper = 1.9
        let expectedOverallPstAtPCCMaxSize = 25.12
        
        let expectedOverallFlickerAtUsBusLower = 1.41
        let expectedOverallFlickerAtUsBusUpper = 1.71
        
        
        let pstDueToLoadAtPCCLower = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCLower(flickerSeverityFactorLower,
                                                                                            furnaceSize: furnaceSize,
                                                                                            threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                            highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                            furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                            compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                            lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadAtPCCUpper = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCHigher(flickerSeverityFactorUpper,
                                                                                             furnaceSize: furnaceSize,
                                                                                             threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                             highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                             furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                             compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                             lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadMaxSize = ElectricArcFurnaceData.calculateMaxSizePstDueToLoadAtPCC(emissionLimit.roundToPlaces(2),
                                                                                           furnaceSize: furnaceSize,
                                                                                           pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCLower = ElectricArcFurnaceData.calculateOverallPstAtPCCLower(backgroundFlicker,
                                                                                        summationLawExponent: summationLawExponent,
                                                                                        pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCUpper = ElectricArcFurnaceData.calculateOverallPstAtPCCHigher(backgroundFlicker,
                                                                                         summationLawExponent: summationLawExponent,
                                                                                         pstDueToLoadAtPCCHigher: pstDueToLoadAtPCCUpper)
        
        let overallPstAtPCCMaxSize = ElectricArcFurnaceData.calculateMaxSizeOverallPstAtPCC(maximumGlobalContribution.roundToPlaces(2),
                                                                                            furnaceSize: furnaceSize,
                                                                                            overallPstAtPCCLower: overallPstAtPCCLower)
        
        let overallFlickerAtUSBusLower = ElectricArcFurnaceData.calculateOverallPstAtUSBusLower(overallPstAtPCCLower,
                                                                                                pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        let overallFlickerAtUSBusHigher = ElectricArcFurnaceData.calculateOverallPstAtUSBusHigher(overallPstAtPCCUpper,
                                                                                                  pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        
        XCTAssert(pstDueToLoadAtPCCLower.roundToPlaces(2) == expectedPstDueToLoadAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCLower) but found \(pstDueToLoadAtPCCLower.roundToPlaces(2))")
        XCTAssert(pstDueToLoadAtPCCUpper.roundToPlaces(2) == expectedPstDueToLoadAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCUpper) but found \(pstDueToLoadAtPCCUpper.roundToPlaces(2))")
        XCTAssert(pstDueToLoadMaxSize.roundToPlaces(2) == expectedPstDueToLoadMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadMaxSize) but found \(pstDueToLoadMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallPstAtPCCLower.roundToPlaces(2) == expectedOverallPstAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCLower) but found \(overallPstAtPCCLower.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCUpper.roundToPlaces(2) == expectedOverallPstAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCUpper) but found \(overallPstAtPCCUpper.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCMaxSize.roundToPlaces(2) == expectedOverallPstAtPCCMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCMaxSize) but found \(overallPstAtPCCMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtUSBusLower.roundToPlaces(2) == expectedOverallFlickerAtUsBusLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusLower) but found \(overallFlickerAtUSBusLower.roundToPlaces(2))")
        XCTAssert(overallFlickerAtUSBusHigher.roundToPlaces(2) == expectedOverallFlickerAtUsBusUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusUpper) but found \(overallFlickerAtUSBusHigher.roundToPlaces(2))")
        
    }

    // Results modified for changes lamp base voltage lower bound correction factor changes from 1.0 to 1.2
    func testCaseTwo_ElectricArcFurnaceFour() {

        let backgroundFlicker = 0.2
        let summationLawExponent = 3.0
        let pccToUpstreamSystemTransferCoefficient = 0.9
        let flickerLimitResults = testCaseTwo_FlickerLimits_Results()
        let maximumGlobalContribution = flickerLimitResults.maximumGlobalContribution
        let emissionLimit = flickerLimitResults.emisisonLimit
        
        let threePhaseShortCircuitStrength = 2215.0
        let furnaceSize = 50.0
        let highReactanceDesign = ElectricArcFurnaceData.HighReactanceDesign.No
        let furnaceType = ElectricArcFurnaceData.FurnaceType.AC
        let compensation = ElectricArcFurnaceData.Compensation.StatCom
        let lampBaseVoltage = ElectricArcFurnaceData.LampBaseVoltage.TwoHundredAndThirtyVolts
        let flickerSeverityFactorLower = 58.0
        let flickerSeverityFactorUpper = 70.0
        
        let expectedPstDueToLoadAtPCCLower = 0.53
        let expectedPstDueToLoadAtPCCUpper = 0.64
        let expectedPstDueToLoadMaxSize = 73.95
        
        let expectedOverallPstAtPCCLower = 0.54
        let expectedOverallPstAtPCCUpper = 0.65
        let expectedOverallPstAtPCCMaxSize = 72.7
        
        let expectedOverallFlickerAtUsBusLower = 0.49
        let expectedOverallFlickerAtUsBusUpper = 0.59
        
        
        let pstDueToLoadAtPCCLower = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCLower(flickerSeverityFactorLower,
                                                                                            furnaceSize: furnaceSize,
                                                                                            threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                            highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                            furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                            compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                            lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadAtPCCUpper = ElectricArcFurnaceData.calculatePstDueToLoadAtPCCHigher(flickerSeverityFactorUpper,
                                                                                             furnaceSize: furnaceSize,
                                                                                             threePhaseShortCircuitStrengthAtPCC: threePhaseShortCircuitStrength,
                                                                                             highReactanceDesignCorrectionFactor: highReactanceDesign.correctionFactor().lower,
                                                                                             furnaceTypeCorrectionFactor: furnaceType.correctionFactor().lower,
                                                                                             compensationCorrectionFactor: compensation.correctionFactor().lower,
                                                                                             lampBaseVoltageCorrectionFactor: lampBaseVoltage.correctionFactor().lower)
        
        let pstDueToLoadMaxSize = ElectricArcFurnaceData.calculateMaxSizePstDueToLoadAtPCC(emissionLimit.roundToPlaces(2),
                                                                                           furnaceSize: furnaceSize,
                                                                                           pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCLower = ElectricArcFurnaceData.calculateOverallPstAtPCCLower(backgroundFlicker,
                                                                                        summationLawExponent: summationLawExponent,
                                                                                        pstDueToLoadAtPCCLower: pstDueToLoadAtPCCLower)
        
        let overallPstAtPCCUpper = ElectricArcFurnaceData.calculateOverallPstAtPCCHigher(backgroundFlicker,
                                                                                         summationLawExponent: summationLawExponent,
                                                                                         pstDueToLoadAtPCCHigher: pstDueToLoadAtPCCUpper)
        
        let overallPstAtPCCMaxSize = ElectricArcFurnaceData.calculateMaxSizeOverallPstAtPCC(maximumGlobalContribution.roundToPlaces(2),
                                                                                            furnaceSize: furnaceSize,
                                                                                            overallPstAtPCCLower: overallPstAtPCCLower)
        
        let overallFlickerAtUSBusLower = ElectricArcFurnaceData.calculateOverallPstAtUSBusLower(overallPstAtPCCLower,
                                                                                                pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        let overallFlickerAtUSBusHigher = ElectricArcFurnaceData.calculateOverallPstAtUSBusHigher(overallPstAtPCCUpper,
                                                                                                  pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        
        
        XCTAssert(pstDueToLoadAtPCCLower.roundToPlaces(2) == expectedPstDueToLoadAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCLower) but found \(pstDueToLoadAtPCCLower.roundToPlaces(2))")
        XCTAssert(pstDueToLoadAtPCCUpper.roundToPlaces(2) == expectedPstDueToLoadAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadAtPCCUpper) but found \(pstDueToLoadAtPCCUpper.roundToPlaces(2))")
        XCTAssert(pstDueToLoadMaxSize.roundToPlaces(2) == expectedPstDueToLoadMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedPstDueToLoadMaxSize) but found \(pstDueToLoadMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallPstAtPCCLower.roundToPlaces(2) == expectedOverallPstAtPCCLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCLower) but found \(overallPstAtPCCLower.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCUpper.roundToPlaces(2) == expectedOverallPstAtPCCUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCUpper) but found \(overallPstAtPCCUpper.roundToPlaces(2))")
        XCTAssert(overallPstAtPCCMaxSize.roundToPlaces(2) == expectedOverallPstAtPCCMaxSize, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallPstAtPCCMaxSize) but found \(overallPstAtPCCMaxSize.roundToPlaces(2))")
        
        XCTAssert(overallFlickerAtUSBusLower.roundToPlaces(2) == expectedOverallFlickerAtUsBusLower, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusLower) but found \(overallFlickerAtUSBusLower.roundToPlaces(2))")
        XCTAssert(overallFlickerAtUSBusHigher.roundToPlaces(2) == expectedOverallFlickerAtUsBusUpper, "Incorrect Pst Due To Load At PCC Lower. Expected \(expectedOverallFlickerAtUsBusUpper) but found \(overallFlickerAtUSBusHigher.roundToPlaces(2))")
        
    }

}
