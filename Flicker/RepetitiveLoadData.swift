//
//  Self.swift
//  Flicker
//
//  Created by Anders Melen on 5/19/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//
//
//
//
//  Don't ask me where, what, why or how all the value arrays came about....
//

import UIKit

protocol RepetitiveLoadProtocol {
    func repetitiveLoadDataDidChange()
    func repetitiveLoadDataDidReset()
    func shapeTypeDidChange()
}


class RepetitiveLoadData: NSUserDefaultSyncable {
    
    fileprivate typealias `Self` = RepetitiveLoadData
    
    static let HELP_PDF_URL = Bundle.main.path(forResource: "Help_Repetitive_Load", ofType: "pdf")!
    static let HELP_TITLE = "Repetitive Load Help"
    
    enum ShapeType : String {
        case Rectangular = "Rectangular"
        case Pulse = "Pulse"
        case Ramp = "Ramp"
        case DoublePulse = "Double Pulse"
        case DoubleRamp = "Double Ramp"
        case Sinusoidal = "Sinusoidal"
        case Triangular = "Triangular"
        case Aperiodic = "Aperiodic"

        static var itemArray : [String] {
            return [ShapeType.Rectangular.rawValue,
                    ShapeType.Pulse.rawValue,
                    ShapeType.Ramp.rawValue,
                    ShapeType.DoublePulse.rawValue,
                    ShapeType.DoubleRamp.rawValue,
                    ShapeType.Sinusoidal.rawValue,
                    ShapeType.Triangular.rawValue,
                    ShapeType.Aperiodic.rawValue]
        }
        
        func index() -> Int? {
            let arrayValues = ShapeType.itemArray
            let index = arrayValues.index(of: self.rawValue)
            return index
        }
        
        
        static var shapeDataIndex : [Double] {
            var data = [Double]()
            
            for i in stride(from: 10.0, through: 90.0, by: 10.0) {
                data.append(i)
            }
            
            for i in stride(from: 100.0, through: 1000.0, by: 100.0) {
                data.append(i)
            }
            
            return data
        }
        
        static var rectangularShapeData : [Double] {
            var data = [Double]()
            
            for _ in 1...18 {
                data.append(1.0)
            }
            
            return data
        }
        
        static let pulseShapeData : [Double] = [0.45,
                                                0.825,
                                                1.1,
                                                1.28,
                                                1.41,
                                                1.46,
                                                1.45,
                                                1.425,
                                                1.4,
                                                1.375,
                                                1.32,
                                                1.3,
                                                1.275,
                                                1.267,
                                                1.25,
                                                1.24,
                                                1.235,
                                                1.23,
                                                1.226]
        
        static let rampShapeData : [Double] = [0.225,
                                               0.425,
                                               0.6,
                                               0.75,
                                               0.86,
                                               0.95,
                                               1,
                                               1.05,
                                               1.06,
                                               1.07,
                                               0.85,
                                               0.74,
                                               0.66,
                                               0.6,
                                               0.56,
                                               0.525,
                                               0.5,
                                               0.475,
                                               0.45]
        
        static let doublePulseShapeData : [Double] = [0.97,
                                                      0.92,
                                                      0.84,
                                                      0.77,
                                                      0.73,
                                                      0.72,
                                                      0.715,
                                                      0.71,
                                                      0.705,
                                                      0.7,
                                                      0.68,
                                                      0.67,
                                                      0.66,
                                                      0.65,
                                                      0.64,
                                                      0.635,
                                                      0.63,
                                                      0.625,
                                                      0.62]
        
        static let doubleRampShapeData : [Double] = [0.98,
                                                     0.95,
                                                     0.91,
                                                     0.88,
                                                     0.85,
                                                     0.81,
                                                     0.78,
                                                     0.74,
                                                     0.71,
                                                     0.67,
                                                     0.5,
                                                     0.41,
                                                     0.35,
                                                     0.3,
                                                     0.27,
                                                     0.26,
                                                     0.23,
                                                     0.21,
                                                     0.2]
        
        static let sinusoidalShapeData : [Double] = [0.08,
                                                     0.13,
                                                     0.17,
                                                     0.21,
                                                     0.24,
                                                     0.27,
                                                     0.3,
                                                     0.33,
                                                     0.35,
                                                     0.37,
                                                     0.49,
                                                     0.55,
                                                     0.63,
                                                     0.71,
                                                     0.75,
                                                     0.76,
                                                     0.763,
                                                     0.766,
                                                     0.77]
        
        static let triangularShapeData : [Double] = [0.07,
                                                     0.11,
                                                     0.14,
                                                     0.17,
                                                     0.2,
                                                     0.22,
                                                     0.24,
                                                     0.26,
                                                     0.28,
                                                     0.29,
                                                     0.4,
                                                     0.46,
                                                     0.5,
                                                     0.68,
                                                     0.62,
                                                     0.63,
                                                     0.63,
                                                     0.63,
                                                     0.63]
        
        
        func shapeTableData() -> [Point<Double>] {
            if self == .Rectangular {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.rectangularShapeData)
            } else if self == .Pulse {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.pulseShapeData)
            } else if self == .Ramp {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.rampShapeData)
            } else if self == .DoublePulse {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.doublePulseShapeData)
            } else if self == .DoubleRamp {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.doubleRampShapeData)
            } else if self == .Sinusoidal {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.sinusoidalShapeData)
            } else if self == .Triangular {
                return ShapeType.createPointData(ShapeType.shapeDataIndex, range: ShapeType.triangularShapeData)
            } else {
                assert(false, "No shape data for \(self)")
                return []
            }
        }
        
        static func createPointData<T>(_ domain: [T], range: [T]) -> [Point<T>] where T: NumericType {
            
            assert(domain.count == range.count, "size of domain and range must match. Found D=\(domain.count) and R=\(range.count)")
            
            var points = [Point<T>]()
            for i in 0 ..< domain.count {
                let point = Point(x: domain[i], y: range[i])
                points.append(point)
            }
            
            return points
        }
        
    }
    
    enum ChangeUnit : String {
        case SixtyHzCycle = "60Hz Cycle"
        case Second = "Second"
        case Minute = "Minute"
        case Hour = "Hour"
        case Day = "Day"
        
        static func arrayStringValues() -> [String] {
            return [ChangeUnit.SixtyHzCycle.rawValue,
                    ChangeUnit.Second.rawValue,
                    ChangeUnit.Minute.rawValue,
                    ChangeUnit.Hour.rawValue,
                    ChangeUnit.Day.rawValue]
        }
        
        func index() -> Int? {
            let arrayValues = ChangeUnit.arrayStringValues()
            let index = arrayValues.index(of: self.rawValue)
            return index
        }
        
        func changeRateAdjustment() -> Double {
            if self == .SixtyHzCycle {
                return 3600.0
            } else if self == .Second {
                return 60.0
            } else if self == .Minute {
                return 1.0
            } else if self == .Hour {
                return 1.0 / 60.0
            } else if self == .Day {
                return 1.0 / 60.0 / 24.0
            } else {
                assert(false, "unrecognized change unit!")
            }
            
            return -1.0
        }
    }
    
    enum TimeOne : String {
        case FourOverSixty = "4/60"
        case SevenOverSixty = "7/60"
        case TenOverSixty = "10/60"
        case ThirteenOverSixty = "13/60"
        case ZeroPointThree = "0.3"
        case ZeroPointSix = "0.6"
        case OnePointFive = "1.5"
        case Four = "4"
        case Five = "5"
        case Six = "6"
        case Eight = "8"
        case Ten = "10"
        case Fifteen = "15"
        case Twenty = "20"
        case Fourty = "40"
        case Sixty = "60"
        case OneHundred = "100"
        case ThreeHundred = "300"
        
        static func arrayStringValues() -> [String] {
            return [TimeOne.FourOverSixty.rawValue,
                    TimeOne.SevenOverSixty.rawValue,
                    TimeOne.TenOverSixty.rawValue,
                    TimeOne.ThirteenOverSixty.rawValue,
                    TimeOne.ZeroPointThree.rawValue,
                    TimeOne.ZeroPointSix.rawValue,
                    TimeOne.OnePointFive.rawValue,
                    TimeOne.Four.rawValue,
                    TimeOne.Five.rawValue,
                    TimeOne.Six.rawValue,
                    TimeOne.Eight.rawValue,
                    TimeOne.Ten.rawValue,
                    TimeOne.Fifteen.rawValue,
                    TimeOne.Twenty.rawValue,
                    TimeOne.Fourty.rawValue,
                    TimeOne.Sixty.rawValue,
                    TimeOne.OneHundred.rawValue,
                    TimeOne.ThreeHundred.rawValue]
        }
        
        func index() -> Int {
            switch self {
            case .FourOverSixty:
                return 0
            case .SevenOverSixty:
                return 1
            case .TenOverSixty:
                return 2
            case .ThirteenOverSixty:
                return 3
            case .ZeroPointThree:
                return 4
            case .ZeroPointSix:
                return 5
            case .OnePointFive:
                return 6
            case .Four:
                return 7
            case .Five:
                return 8
            case .Six:
                return 9
            case .Eight:
                return 10
            case .Ten:
                return 11
            case .Fifteen:
                return 12
            case .Twenty:
                return 13
            case .Fourty:
                return 14
            case .Sixty:
                return 15
            case .OneHundred:
                return 16
            case .ThreeHundred:
                return 17
            }
        }
    }
    
    enum TimeTwo : String {
        case ZeroPointZeroOneSeven = "0.017"
        case ZeroPointZeroTwo = "0.02"
        case ZeroPointZeroThree = "0.03"
        case ZeroPointZeroFour = "0.04"
        case ZeroPointZeroFive = "0.05"
        case ZeroPointZeroSix = "0.06"
        case ZeroPointZeroSeven = "0.07"
        case ZeroPointZeroEight = "0.08"
        case ZeroPointZeroNine = "0.09"
        case ZeroPointOne = "0.1"
        case ZeroPointTwo = "0.2"
        case ZeroPointThree = "0.3"
        case ZeroPointFour = "0.4"
        case ZeroPointFive = "0.5"
        case ZeroPointSix = "0.6"
        case ZeroPointSeven = "0.7"
        case ZeroPointEight = "0.8"
        case ZeroPointNine = "0.9"
        case One = "1"
        case Two = "2"
        case Three = "3"
        case Four = "4"
        case Five = "5"
        case Six = "6"
        case Seven = "7"
        case Eight = "8"
        case Nine = "9"
        case Ten = "10"
        case Twenty = "20"
        case Thirty = "30"
        case Fourty = "40"
        case Fifty = "50"
        case Sixty = "60"
        case Seventy = "70"
        case Eighty = "80"
        case Ninety = "90"
        case OneHundred = "100"
        
        static func arrayStringValues() -> [String] {
            return [TimeTwo.ZeroPointZeroOneSeven.rawValue,
                    TimeTwo.ZeroPointZeroTwo.rawValue,
                    TimeTwo.ZeroPointZeroThree.rawValue,
                    TimeTwo.ZeroPointZeroFour.rawValue,
                    TimeTwo.ZeroPointZeroFive.rawValue,
                    TimeTwo.ZeroPointZeroSix.rawValue,
                    TimeTwo.ZeroPointZeroSeven.rawValue,
                    TimeTwo.ZeroPointZeroEight.rawValue,
                    TimeTwo.ZeroPointZeroNine.rawValue,
                    TimeTwo.ZeroPointOne.rawValue,
                    TimeTwo.ZeroPointTwo.rawValue,
                    TimeTwo.ZeroPointThree.rawValue,
                    TimeTwo.ZeroPointFour.rawValue,
                    TimeTwo.ZeroPointFive.rawValue,
                    TimeTwo.ZeroPointSix.rawValue,
                    TimeTwo.ZeroPointSeven.rawValue,
                    TimeTwo.ZeroPointEight.rawValue,
                    TimeTwo.ZeroPointNine.rawValue,
                    TimeTwo.One.rawValue,
                    TimeTwo.Two.rawValue,
                    TimeTwo.Three.rawValue,
                    TimeTwo.Four.rawValue,
                    TimeTwo.Five.rawValue,
                    TimeTwo.Six.rawValue,
                    TimeTwo.Seven.rawValue,
                    TimeTwo.Eight.rawValue,
                    TimeTwo.Nine.rawValue,
                    TimeTwo.Ten.rawValue,
                    TimeTwo.Twenty.rawValue,
                    TimeTwo.Thirty.rawValue,
                    TimeTwo.Fourty.rawValue,
                    TimeTwo.Fifty.rawValue,
                    TimeTwo.Sixty.rawValue,
                    TimeTwo.Seventy.rawValue,
                    TimeTwo.Eighty.rawValue,
                    TimeTwo.Ninety.rawValue,
                    TimeTwo.OneHundred.rawValue]
        }
        
        func index() -> Int {
            switch self {
            case .ZeroPointZeroOneSeven:
                return 0
            case .ZeroPointZeroTwo:
                return 1
            case .ZeroPointZeroThree:
                return 2
            case .ZeroPointZeroFour:
                return 3
            case .ZeroPointZeroFive:
                return 4
            case .ZeroPointZeroSix:
                return 5
            case .ZeroPointZeroSeven:
                return 6
            case .ZeroPointZeroEight:
                return 7
            case .ZeroPointZeroNine:
                return 8
            case .ZeroPointOne:
                return 9
            case .ZeroPointTwo:
                return 10
            case .ZeroPointThree:
                return 11
            case .ZeroPointFour:
                return 12
            case .ZeroPointFive:
                return 13
            case .ZeroPointSix:
                return 14
            case .ZeroPointSeven:
                return 15
            case .ZeroPointEight:
                return 16
            case .ZeroPointNine:
                return 17
            case .One:
                return 18
            case .Two:
                return 19
            case .Three:
                return 20
            case .Four:
                return 21
            case .Five:
                return 22
            case .Six:
                return 23
            case .Seven:
                return 24
            case .Eight:
                return 25
            case .Nine:
                return 26
            case .Ten:
                return 27
            case .Twenty:
                return 28
            case .Thirty:
                return 29
            case .Fourty:
                return 30
            case .Fifty:
                return 31
            case .Sixty:
                return 32
            case .Seventy:
                return 33
            case .Eighty:
                return 34
            case .Ninety:
                return 35
            case .OneHundred:
                return 36
            }
        }
    }
    
    // MARK: - Delegates
    var delegates = [RepetitiveLoadProtocol]()
    
    // MARK: - NSUserDefault Keys + Calculated Property Descriptor Strings
    static let SHAPE_TYPE = "Shape Type"
    static let CHANGE_RATE = "Change Rate"
    static let CHANGE_UNIT = "Change Unit"
    static let DELTA_VV_AT_PCC = "Delta V/V at PCC (%)"
    static let DURATION_OF_VOLTAGE_CHANGE = "Duration of Voltage Change (ms)"
    static let LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC = "Load Amps Resulting in Delta V/V% at PCC"
    static let TIME_ONE = "Time One (sec)"
    static let TIME_TWO = "Time Two (sec)"
    
    static let SHAPE_FACTOR = "Shape Factor"
    
    static let USER_DEFAULT_KEYS = [Self.SHAPE_TYPE,
                                    Self.CHANGE_RATE,
                                    Self.CHANGE_UNIT,
                                    Self.DELTA_VV_AT_PCC,
                                    Self.DURATION_OF_VOLTAGE_CHANGE,
                                    Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC,
                                    Self.TIME_ONE,
                                    Self.TIME_TWO,
                                    Self.SHAPE_FACTOR]
    
    // MARK: - Parameters
    // MARK: Static
    static var aOneTable : [Point<Double>] {
        var points = [Point<Double>]()
        points.append(Point(x: 0.1, y: 8.202))
        points.append(Point(x: 0.2, y: 5.232))
        points.append(Point(x: 0.4, y: 4.062))
        points.append(Point(x: 0.6, y: 3.645))
        points.append(Point(x: 1, y: 3.166))
        points.append(Point(x: 2, y: 2.568))
        points.append(Point(x: 3, y: 2.25))
        points.append(Point(x: 5, y: 1.899))
        points.append(Point(x: 7, y: 1.695))
        points.append(Point(x: 10, y: 1.499))
        points.append(Point(x: 22, y: 1.186))
        points.append(Point(x: 39, y: 1.044))
        points.append(Point(x: 48, y: 1))
        points.append(Point(x: 68, y: 0.939))
        points.append(Point(x: 110, y: 0.841))
        points.append(Point(x: 176, y: 0.739))
        points.append(Point(x: 273, y: 0.65))
        points.append(Point(x: 375, y: 0.594))
        points.append(Point(x: 480, y: 0.559))
        points.append(Point(x: 585, y: 0.501))
        points.append(Point(x: 682, y: 0.445))
        points.append(Point(x: 796, y: 0.393))
        points.append(Point(x: 1020, y: 0.35))
        points.append(Point(x: 1055, y: 0.351))
        points.append(Point(x: 1200, y: 0.371))
        points.append(Point(x: 1390, y: 0.438))
        points.append(Point(x: 1620, y: 0.547))
        points.append(Point(x: 2400, y: 1.051))
        points.append(Point(x: 2875, y: 1.498))
        return points
    }
    
    static var aperiodicTable : [[Double]] {
        var data = [[Double]]()
        data.append([2.7500,2.530,2.110,1.950,1.720,1.460,1.225,0.985,0.955,0.930,0.870,0.830,0.770,0.730,0.680,0.660,0.640,0.610])
        data.append([3.2500,2.880,2.430,2.265,2.005,1.690,1.415,1.170,1.165,1.075,1.000,0.954,0.875,0.825,0.750,0.715,0.680,0.636])
        data.append([4.4250,3.645,3.160,2.960,2.630,2.220,1.840,1.560,1.480,1.390,1.290,1.215,1.100,1.015,0.900,0.840,0.775,0.685])
        data.append([5.1500,4.140,3.655,3.410,3.075,2.600,2.150,1.775,1.670,1.570,1.450,1.365,1.225,1.130,0.975,0.905,0.830,0.725])
        data.append([5.5700,4.405,3.980,3.710,3.385,2.860,2.375,1.880,1.763,1.655,1.530,1.435,1.290,1.190,1.010,0.935,0.860,0.754])
        data.append([5.5650,4.395,4.050,3.785,3.435,2.915,2.445,1.940,1.815,1.710,1.574,1.475,1.325,1.225,1.030,0.950,0.870,0.765])
        data.append([5.4150,4.280,4.015,3.760,3.410,2.905,2.460,1.975,1.845,1.740,1.596,1.495,1.344,1.244,1.050,0.965,0.875,0.767])
        data.append([5.1550,4.145,3.900,3.665,3.350,2.870,2.455,1.990,1.860,1.760,1.610,1.510,1.350,1.250,1.055,0.970,0.880,0.769])
        data.append([4.9200,4.020,3.785,3.570,3.295,2.835,2.445,2.005,1.875,1.770,1.620,1.515,1.355,1.255,1.060,0.974,0.881,0.773])
        data.append([4.7000,3.905,3.675,3.480,3.235,2.795,2.430,2.010,1.880,1.780,1.625,1.520,1.355,1.260,1.065,0.975,0.880,0.775])
        data.append([3.7250,3.290,3.155,3.035,2.900,2.580,2.305,1.975,1.860,1.774,1.620,1.510,1.344,1.254,1.070,0.975,0.874,0.770])
        data.append([3.4000,3.040,2.965,2.880,2.750,2.475,2.230,1.925,1.830,1.745,1.605,1.500,1.334,1.240,1.060,0.966,0.865,0.765])
        data.append([3.2300,2.895,2.855,2.780,2.655,2.410,2.175,1.890,1.795,1.720,1.590,1.490,1.325,1.235,1.050,0.960,0.864,0.757])
        data.append([3.1000,2.790,2.770,2.705,2.590,2.360,2.135,1.860,1.775,1.700,1.575,1.480,1.320,1.225,1.040,0.954,0.860,0.755])
        data.append([3.0000,2.710,2.695,2.640,2.535,2.325,2.105,1.830,1.750,1.680,1.564,1.466,1.314,1.220,1.035,0.950,0.857,0.753])
        data.append([2.9100,2.645,2.635,2.590,2.490,2.290,2.075,1.810,1.735,1.664,1.550,1.460,1.310,1.215,1.030,0.945,0.856,0.751])
        data.append([2.8350,2.590,2.580,2.540,2.450,2.255,2.045,1.795,1.715,1.650,1.540,1.450,1.300,1.210,1.025,0.940,0.854,0.749])
        data.append([2.7700,2.540,2.535,2.500,2.415,2.230,2.025,1.780,1.700,1.635,1.530,1.440,1.295,1.205,1.024,0.938,0.853,0.747])
        data.append([2.7050,2.495,2.490,2.455,2.380,2.205,2.005,1.760,1.685,1.624,1.515,1.430,1.290,1.200,1.020,0.935,0.851,0.745])
        data.append([2.3300,2.205,2.195,2.190,2.155,2.025,1.855,1.655,1.590,1.534,1.440,1.365,1.245,1.165,1.000,0.925,0.846,0.743])
        data.append([2.1150,2.030,2.025,2.020,2.015,1.900,1.765,1.585,1.525,1.475,1.394,1.325,1.215,1.145,0.994,0.920,0.844,0.742])
        data.append([1.9700,1.905,1.905,1.900,1.895,1.805,1.685,1.525,1.475,1.435,1.360,1.300,1.196,1.134,0.985,0.915,0.842,0.741])
        data.append([1.8600,1.815,1.805,1.800,1.795,1.730,1.625,1.480,1.435,1.395,1.330,1.275,1.185,1.120,0.980,0.913,0.840,0.740])
        data.append([1.7750,1.745,1.730,1.725,1.72,1.665,1.570,1.440,1.400,1.365,1.305,1.256,1.175,1.110,0.975,0.910,0.838,0.740])
        data.append([1.7100,1.685,1.670,1.660,1.650,1.610,1.525,1.405,1.370,1.340,1.284,1.240,1.160,1.104,0.970,0.905,0.836,0.740])
        data.append([1.6500,1.640,1.605,1.6,1.595,1.560,1.485,1.375,1.340,1.314,1.265,1.225,1.150,1.094,0.965,0.903,0.834,0.740])
        data.append([1.6000,1.590,1.555,1.55,1.545,1.515,1.440,1.350,1.315,1.290,1.245,1.210,1.140,1.085,0.960,0.900,0.832,0.740])
        data.append([1.5550,1.545,1.505,1.5,1.495,1.480,1.410,1.320,1.290,1.270,1.230,1.195,1.130,1.076,0.955,0.897,0.830,0.740])
        data.append([1.3050,1.295,1.255,1.245,1.24,1.235,1.185,1.145,1.130,1.115,1.100,1.085,1.045,1.014,0.920,0.880,0.815,0.740])
        data.append([1.1800,1.170,1.135,1.125,1.12,1.115,1.065,1.040,1.030,1.020,1.020,1.005,0.975,0.955,0.895,0.857,0.810,0.739])
        data.append([1.1050,1.095,1.055,1.045,1.04,1.035,0.995,0.985,0.980,0.970,0.965,0.95,0.935,0.920,0.875,0.844,0.804,0.736])
        data.append([1.0500,1.040,1.000,0.995,0.99,0.985,0.945,0.935,0.925,0.920,0.910,0.905,0.900,0.886,0.860,0.830,0.797,0.733])
        data.append([1.0050,1.000,0.960,0.955,0.95,0.945,0.910,0.905,0.895,0.890,0.885,0.880,0.875,0.870,0.840,0.820,0.790,0.730])
        data.append([0.9700,0.965,0.930,0.925,0.92,0.915,0.885,0.880,0.870,0.865,0.860,0.855,0.850,0.845,0.830,0.812,0.785,0.727])
        data.append([0.9450,0.940,0.905,0.9,0.895,0.890,0.865,0.860,0.855,0.850,0.845,0.840,0.835,0.830,0.820,0.810,0.780,0.724])
        data.append([0.9250,0.920,0.885,0.88,0.875,0.870,0.850,0.845,0.840,0.835,0.830,0.825,0.820,0.815,0.810,0.800,0.775,0.721])
        data.append([0.9100,0.905,0.865,0.86,0.855,0.850,0.840,0.840,0.830,0.825,0.820,0.815,0.810,0.810,0.805,0.795,0.770,0.718])
        return data
    }
    
    // MARK: Outputs
    fileprivate(set) var flickerDueToLoadAtPCCPst : Double?
    fileprivate(set) var overallFlickerAtPCCPst : Double?
    fileprivate(set) var overallFlickerAtUSBusPst : Double?
    fileprivate(set) var flickerDueToLoadAtPCCMaxCurrent : Double?
    fileprivate(set) var overallFlickerAtPCCMaxCurrent: Double?
    fileprivate(set) var shapeFactor: Double?
    
    // MARK: Inputs
    fileprivate var _timeOne : TimeOne?
    var timeOne : TimeOne? {
        set {
            if newValue != _timeOne {
                _timeOne = newValue
                
                Self.saveTimeOneToNSUserDefaults(self.timeOne)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _timeOne }
    }
    
    fileprivate var _timeTwo : TimeTwo?
    var timeTwo : TimeTwo? {
        set {
            if newValue != _timeTwo {
                _timeTwo = newValue
                
                Self.saveTimeTwoToNSUserDefaults(self.timeTwo)

                self.recalculateOutputParameters()
            }
        }
        get { return _timeTwo }
    }
    
    fileprivate var _shapeType : ShapeType?
    var shapeType : ShapeType? {
        set {
            if newValue != _shapeType {
                _shapeType = newValue
                
                Self.saveShapeTypeToNSUserDefaults(self.shapeType)
                
                for delegate in self.delegates {
                    delegate.shapeTypeDidChange()
                }
                
                self.recalculateOutputParameters()
            }
        }
        get { return _shapeType }
    }
    
    fileprivate var _changeRate : Double?
    var changeRate : Double? {
        set {
            if newValue != _changeRate {
                _changeRate = newValue
                
                Self.saveObjectToNSUserDefaults(Self.CHANGE_RATE, value: self.changeRate as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _changeRate }
    }
    
    fileprivate var _changeUnit : ChangeUnit?
    var changeUnit : ChangeUnit? {
        set {
            if newValue != _changeUnit {
                _changeUnit = newValue
                
                Self.saveChangeUnitToNSUserDefaults(self.changeUnit)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _changeUnit }
    }
    
    fileprivate var _deltaVVAtPCC : Double?
    var deltaVVAtPCC : Double? {
        set {
            if newValue != _deltaVVAtPCC {
                _deltaVVAtPCC = newValue
                
                Self.saveObjectToNSUserDefaults(Self.DELTA_VV_AT_PCC, value: self.deltaVVAtPCC as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _deltaVVAtPCC }
    }
    
    fileprivate var _durationOfVoltageChange : Double?
    var durationOfVoltageChange : Double? {
        set {
            if newValue != _durationOfVoltageChange {
                _durationOfVoltageChange = newValue
                
                Self.saveObjectToNSUserDefaults(Self.DURATION_OF_VOLTAGE_CHANGE, value: self.durationOfVoltageChange as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _durationOfVoltageChange }
    }
    
    fileprivate var _loadAmpsResultingInDeltaVVPercentAtPCC : Double?
    var loadAmpsResultingInDeltaVVPercentAtPCC : Double? {
        set {
            if newValue != _loadAmpsResultingInDeltaVVPercentAtPCC {
                _loadAmpsResultingInDeltaVVPercentAtPCC = newValue
                
                Self.saveObjectToNSUserDefaults(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC, value: self.loadAmpsResultingInDeltaVVPercentAtPCC as AnyObject?)
                
                self.recalculateOutputParameters()
            }
        }
        get { return _loadAmpsResultingInDeltaVVPercentAtPCC }
    }
    
    
    // MARK: - Singlton Constructor
    static let sharedInstance = RepetitiveLoadData()
    
    // MARK: - Constructor
    override init() {
        super.init()
        
        self.setDefaultValuesIfNil()
        
        FlickerLimits.sharedInstance.delegates.append(self)
        
        self.loadFromNSUserDefaults()
        
        self.recalculateOutputParameters()
    }
    
    fileprivate func setDefaultValuesIfNil() {
        let changeUnit: ChangeUnit? = Self.loadChangeUnitFromNSUserDefaults()
        if changeUnit == nil {
            Self.saveChangeUnitToNSUserDefaults(ChangeUnit.SixtyHzCycle)
        }
    }
    
    // MARK: - Resetting
    func reset() {
        
        Self.saveObjectToNSUserDefaults(Self.SHAPE_TYPE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.CHANGE_RATE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.CHANGE_UNIT, value: nil)
        Self.saveObjectToNSUserDefaults(Self.DELTA_VV_AT_PCC, value: nil)
        Self.saveObjectToNSUserDefaults(Self.DURATION_OF_VOLTAGE_CHANGE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC, value: nil)
        Self.saveObjectToNSUserDefaults(Self.TIME_ONE, value: nil)
        Self.saveObjectToNSUserDefaults(Self.TIME_TWO, value: nil)
        Self.saveObjectToNSUserDefaults(Self.SHAPE_FACTOR, value: nil)
        
        self.setDefaultValuesIfNil()
        
        self.loadFromNSUserDefaults()
        
        for delegate in self.delegates {
            delegate.repetitiveLoadDataDidReset()
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
        
        if let shapeType = self.shapeType {
            
            if shapeType == .Rectangular {
                missing += self.rectangularMissingInputs()
            } else if shapeType == .Pulse {
                missing += self.pulseMissingInputs()
            } else if shapeType == .Ramp {
                missing += self.rampMissingInputs()
            } else if shapeType == .DoublePulse {
                missing += self.doubleRampMissingInputs()
            } else if shapeType == .DoubleRamp {
                missing += self.doubleRampMissingInputs()
            } else if shapeType == .Sinusoidal{
                missing += self.sinusoidalMissingInputs()
            } else if shapeType == .Triangular {
                missing += self.triangularMissingInputs()
            } else if shapeType == .Aperiodic {
                missing += self.aperiodicMissingInputs()
            } else {
                assert(false, "No missing inputs function found for shape type \(shapeType)")
            }
            
        } else {
            missing.append(Self.SHAPE_TYPE)
            missing.append("Other inputs may also be missing")
        }
        return missing
    }

    fileprivate func rectangularMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    fileprivate func pulseMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.durationOfVoltageChange == nil {
            missing.append(Self.DURATION_OF_VOLTAGE_CHANGE)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    
    fileprivate func rampMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.durationOfVoltageChange == nil {
            missing.append(Self.DURATION_OF_VOLTAGE_CHANGE)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    fileprivate func doublePulseMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.durationOfVoltageChange == nil {
            missing.append(Self.DURATION_OF_VOLTAGE_CHANGE)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    fileprivate func doubleRampMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.durationOfVoltageChange == nil {
            missing.append(Self.DURATION_OF_VOLTAGE_CHANGE)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    fileprivate func sinusoidalMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    fileprivate func triangularMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.changeRate == nil {
            missing.append(Self.CHANGE_RATE)
        }
        
        if self.changeUnit == nil {
            missing.append(Self.CHANGE_UNIT)
        }
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    fileprivate func aperiodicMissingInputs() -> [String] {
        
        var missing = [String]()
        
        if self.deltaVVAtPCC == nil {
            missing.append(Self.DELTA_VV_AT_PCC)
        }
        
        if self.timeOne == nil {
            missing.append(Self.TIME_ONE)
        }
        
        if self.timeTwo == nil {
            missing.append(Self.TIME_TWO)
        }
        
        if self.loadAmpsResultingInDeltaVVPercentAtPCC == nil {
            missing.append(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        }
        
        return missing
    }
    
    // MARK: Within Limits
    func withinLimits() -> Bool {
        
        var valid = false
        
        if self.flickerDueToLoadAtPCCPstValid() &&
            self.overallFlickerAtPCCPstValid() {
            
            valid = true
            
        }
        
        return valid
    }
    
    func flickerDueToLoadAtPCCPstValid() -> Bool {
        
        var valid = false
        
        if let emissionLimit = FlickerLimits.sharedInstance.emissionLimit,
            let flickerDueToLoadAtPCCPst = self.flickerDueToLoadAtPCCPst {
            
            if flickerDueToLoadAtPCCPst.roundToPlaces(2) <= emissionLimit.roundToPlaces(2) {
                valid = true
            }
            
        }
        
        return valid
    }
    
    func overallFlickerAtPCCPstValid() -> Bool {
        
        var valid = false
        
        if let maximumGlobalContribution = FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC,
            let overallFlickerAtPCCPst = self.overallFlickerAtPCCPst {
            
            if overallFlickerAtPCCPst.roundToPlaces(2) <= maximumGlobalContribution.roundToPlaces(2) {
                valid = true
            }
            
        }
        
        return valid
    }
    
    
    // MARK: - Property Setting Validation
    func invalidInputs() -> [String] {
        
        var invalidInputs = [String]()
        
        if let shapeType = self.shapeType {
            
            if let changeRate = self.changeRate,
                let changeUnit = self.changeUnit {
                
                if Self.changeRateIsValid(shapeType,
                changeRate: changeRate,
                changeUnit: changeUnit).valid == false {

                    
                    invalidInputs.append(Self.CHANGE_RATE)
                    invalidInputs.append(Self.CHANGE_UNIT)
                    
                }
                
            }
            
            if let durationOfVoltageChange = self.durationOfVoltageChange {
                
                if Self.durationOfVoltageChangeIsValid(shapeType,
                                                       durationOfVoltageChange: durationOfVoltageChange).valid == false {
                    
                    invalidInputs.append(Self.DURATION_OF_VOLTAGE_CHANGE)
                    
                }
                
            }
        }
        
        return invalidInputs
    }
    
    static func changeRateIsValid(_ shapeType: ShapeType,
                                  changeRate: Double,
                                  changeUnit: ChangeUnit) -> (valid: Bool, errorMessage: String?) {
        
        if shapeType == .Sinusoidal ||
            shapeType == .Triangular {
            
            if changeRate < Self.changeRateShapeDataBounds(changeUnit).lower ||
                changeRate > Self.changeRateShapeDataBounds(changeUnit).upper {
                
                return (false, String.init(format: "Change Rate must be within bounds [%.6f,%.6f]", Self.changeRateShapeDataBounds(changeUnit).lower, Self.changeRateAOneDataBounds(changeUnit).upper))
                
            }
            
        } else {
         
            if changeRate < Self.changeRateAOneDataBounds(changeUnit).lower ||
                changeRate > Self.changeRateAOneDataBounds(changeUnit).upper {
                
                return (false, String.init(format: "Change Rate must be within bounds [%.6f,%.6f]", Self.changeRateAOneDataBounds(changeUnit).lower, Self.changeRateAOneDataBounds(changeUnit).upper))
                
            }
            
        }
        
        return (true, nil)
    }
    
    static func durationOfVoltageChangeIsValid(_ shapeType: ShapeType,
                                               durationOfVoltageChange: Double) -> (valid: Bool, errorMessage: String?) {
        
        if shapeType == .Pulse ||
            shapeType == .Ramp ||
            shapeType == .DoublePulse ||
            shapeType == .DoubleRamp {
            
            if durationOfVoltageChange < Self.ShapeType.shapeDataIndex.first! ||
                durationOfVoltageChange > Self.ShapeType.shapeDataIndex.last! {
                
                let errorMessage = "Duration of Voltage Change must be within bounds [\(Self.ShapeType.shapeDataIndex.first!),\(Self.ShapeType.shapeDataIndex.last!)]"
                return (false, errorMessage)
            }
            
        }
        
        return (true, nil)
    }
    
    
    // MARK: - NSUserDefault Interface
    // MARK: Custom Type Savers
    fileprivate static func saveShapeTypeToNSUserDefaults(_ shapeType: ShapeType?) {
        Self.saveObjectToNSUserDefaults(Self.SHAPE_TYPE, value: shapeType?.rawValue as AnyObject?)
    }
    
    fileprivate static func saveChangeUnitToNSUserDefaults(_ changeUnit: ChangeUnit?) {
        Self.saveObjectToNSUserDefaults(Self.CHANGE_UNIT, value: changeUnit?.rawValue as AnyObject?)
    }
    
    fileprivate static func saveTimeOneToNSUserDefaults(_ timeOne: TimeOne?) {
        Self.saveObjectToNSUserDefaults(Self.TIME_ONE, value: timeOne?.rawValue as AnyObject?)
    }
    
    fileprivate static func saveTimeTwoToNSUserDefaults(_ timeTwo: TimeTwo?) {
        Self.saveObjectToNSUserDefaults(Self.TIME_TWO, value: timeTwo?.rawValue as AnyObject?)
    }
    
    // MARK: Custom Type Loaders
    fileprivate static func loadShapeTypeFromNSUserDefaults() -> ShapeType? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.SHAPE_TYPE),
            let shapeType = ShapeType.init(rawValue: stringValue!) {
            return shapeType
        } else {
            return nil
        }
    }
    
    fileprivate static func loadChangeUnitFromNSUserDefaults() -> ChangeUnit? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.CHANGE_UNIT),
            let changeUnit = ChangeUnit.init(rawValue: stringValue!) {
            return changeUnit
        } else {
            return nil
        }
    }
    
    fileprivate static func loadTimeOneFromNSUserDefaults() -> TimeOne? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.TIME_ONE),
            let timeOne = TimeOne.init(rawValue: stringValue!) {
            return timeOne
        } else {
            return nil
        }
    }
    
    fileprivate static func loadTimeTwoFromNSUserDefaults() -> TimeTwo? {
        if let stringValue : String? = Self.loadObjectFromNSUserDefaults(Self.TIME_TWO),
            let timeTwo = TimeTwo.init(rawValue: stringValue!) {
            return timeTwo
        } else {
            return nil
        }
    }
    
    // MARK: Load
    func loadFromNSUserDefaults() {
        
        _shapeType = Self.loadShapeTypeFromNSUserDefaults()
        _changeRate = Self.loadObjectFromNSUserDefaults(Self.CHANGE_RATE)
        _changeUnit = Self.loadChangeUnitFromNSUserDefaults()
        _deltaVVAtPCC = Self.loadObjectFromNSUserDefaults(Self.DELTA_VV_AT_PCC)
        _durationOfVoltageChange = Self.loadObjectFromNSUserDefaults(Self.DURATION_OF_VOLTAGE_CHANGE)
        _loadAmpsResultingInDeltaVVPercentAtPCC = Self.loadObjectFromNSUserDefaults(Self.LOAD_AMPS_RESULTING_IN_DELTA_VV_PERCENT_AT_PCC)
        _timeOne = Self.loadTimeOneFromNSUserDefaults()
        _timeTwo = Self.loadTimeTwoFromNSUserDefaults()
        
        if _shapeType == nil {
            self.shapeType = ShapeType.Rectangular
        }
    }
    
    // MARK: - Formatted Output Strings
    static func formattedDoubleValue(_ value: Double?, decimalPlaces: Int = 2, emptyValue: String = "") -> String {
        if let value = value {
            let formatString = "%.\(decimalPlaces)f"
            return String.init(format: formatString, value)
        } else {
            return emptyValue
        }
    }
    
    // MARK: - Outputs
    fileprivate func recalculateOutputParameters() {
        
        if let shapeType = self.shapeType {
            self.shapeFactor = Self.calculateShapeFactor(shapeType,
                                                         durationOfVoltageChange: self.durationOfVoltageChange,
                                                         changeRate: self.changeRate,
                                                         changeUnit: self.changeUnit)
        } else {
            self.shapeFactor = nil
        }
        
        if let shapeType = self.shapeType,
            let deltaVVAtPCC = self.deltaVVAtPCC {
            self.flickerDueToLoadAtPCCPst = self.calculateFlickerDueToLoadAtPCCPst(shapeType,
                                                                                   deltaVVAtPCC: deltaVVAtPCC)
        } else {
            self.flickerDueToLoadAtPCCPst = nil
        }

        if let backgroundFlicker = FlickerLimits.sharedInstance.backgroundFlicker,
            let flickerDueToLoadAtPCCPst = self.flickerDueToLoadAtPCCPst,
            let summationLawExponent = FlickerLimits.sharedInstance.summationLawExponent {
            
            self.overallFlickerAtPCCPst = Self.calculateOverallFlickerAtPCCPst(backgroundFlicker,
                                                                               flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                               summationLawExponent: summationLawExponent)
        } else {
            self.overallFlickerAtPCCPst = nil
        }
        
        
        if let overallFlickerAtPCCPst = self.overallFlickerAtPCCPst,
            let pccToUpstreamSystemTransferCoefficient = FlickerLimits.sharedInstance.pccToUpstreamSystemTransferCoefficient {
            self.overallFlickerAtUSBusPst = Self.calculateOverallFlickerAtUSBusPst(overallFlickerAtPCCPst,
                                                                                   pccToUpstreamSystemTransferCoefficient: pccToUpstreamSystemTransferCoefficient)
        } else {
            self.overallFlickerAtUSBusPst = nil
        }

        
        if let emissionLimit = FlickerLimits.sharedInstance.emissionLimit,
            let flickerDueToLoadAtPCCPst = self.flickerDueToLoadAtPCCPst,
            let loadAmpsResultingInDeltaVVPercentAtPCC = self.loadAmpsResultingInDeltaVVPercentAtPCC {
            self.flickerDueToLoadAtPCCMaxCurrent = Self.calculateFlickerDueToLoadAtPCCMaxCurrent(emissionLimit,
                                                                                                 flickerDueToLoadAtPCCPst: flickerDueToLoadAtPCCPst,
                                                                                                 loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVPercentAtPCC)
        } else {
            self.flickerDueToLoadAtPCCMaxCurrent = nil
        }
        
        if let maximumGlobalContributionAtPCC = FlickerLimits.sharedInstance.maximumGlobalContributionAtPCC,
            let overallFlickerAtPCCPst = self.overallFlickerAtPCCPst,
            let loadAmpsResultingInDeltaVVPercentAtPCC = self.loadAmpsResultingInDeltaVVPercentAtPCC {
            self.overallFlickerAtPCCMaxCurrent = Self.calculateOverallFlickerAtPCCMaxCurrent(maximumGlobalContributionAtPCC,
                                                                                             overallFlickerAtPCCPst: overallFlickerAtPCCPst,
                                                                                             loadAmpsResultingInDeltaVVPercentAtPCC: loadAmpsResultingInDeltaVVPercentAtPCC)
        } else {
            self.overallFlickerAtPCCMaxCurrent = nil
        }
        
    
        self.notifyDelegatesOfRepetitiveLoadChanges()
    }
    
    fileprivate func notifyDelegatesOfRepetitiveLoadChanges() {
        for delegate in self.delegates {
            delegate.repetitiveLoadDataDidChange()
        }
    }
    
    internal func calculateFlickerDueToLoadAtPCCPst(_ shapeType: ShapeType,
                                                    deltaVVAtPCC: Double) -> Double? {

        var flickerDueToLoadAtPCCPst: Double?
        
            if shapeType == .Aperiodic {

                if let timeOne = self.timeOne,
                    let timeTwo = self.timeTwo {
            
                    flickerDueToLoadAtPCCPst = Self.calculateFlickerDueToLoadAtPCCPstForAperiodic(timeOne,
                                                                                                  timeTwo: timeTwo,
                                                                                                  deltaVVAtPCC: deltaVVAtPCC)
                }
            
            } else {
                
                if let changeRate = self.changeRate,
                    let changeUnit = self.changeUnit,
                    let shapeFactor = self.shapeFactor {
                    
                    if let dPSTOne = Self.calculateDPstOne(changeRate,
                                                           changeUnit: changeUnit) {
                        
                        flickerDueToLoadAtPCCPst = Self.calculateFlickerDueToLoadAtPCCPstForNonAperiodic(dPSTOne,
                                                                                                         shapeFactor: shapeFactor,
                                                                                                         deltaVVAtPCC: deltaVVAtPCC)
                        
                    }
                }
                
            }
        
        return flickerDueToLoadAtPCCPst
    }
    
    internal static func calculateFlickerDueToLoadAtPCCPstForAperiodic(_ timeOne: TimeOne,
                                                                       timeTwo: TimeTwo,
                                                                       deltaVVAtPCC: Double) -> Double {
        
        let timeOneIndex = timeOne.index()
        let timeTwoIndex = timeTwo.index()
        
        
        let aperiodicValue = Self.aperiodicTable[timeTwoIndex][timeOneIndex]
        let flickerDueToLoadAtPCCPstForAperiodic = (deltaVVAtPCC / 2.0) * aperiodicValue
        return flickerDueToLoadAtPCCPstForAperiodic
        
    }
    
    internal static func calculateFlickerDueToLoadAtPCCPstForNonAperiodic(_ dpstOne: Double,
                                                                          shapeFactor: Double,
                                                                          deltaVVAtPCC: Double) -> Double {
        
        let flickerDueToLoadAtPCCPsForNonAperiodic = (deltaVVAtPCC / dpstOne) * shapeFactor
        return flickerDueToLoadAtPCCPsForNonAperiodic
        
    }
    
    internal static func calculateOverallFlickerAtPCCPst(_ backgroundFlicker: Double,
                                                         flickerDueToLoadAtPCCPst: Double,
                                                         summationLawExponent: Double) -> Double {
        
        let backgroundFlickerComponent = pow(backgroundFlicker, summationLawExponent)
        let flickerDueToLoadAtPCCPstComponent = pow(flickerDueToLoadAtPCCPst, summationLawExponent)
        
        let overallFlickerAtPCCPst = pow(backgroundFlickerComponent + flickerDueToLoadAtPCCPstComponent, (1.0 / summationLawExponent))
        return overallFlickerAtPCCPst
        
    }
    
    internal static func calculateOverallFlickerAtUSBusPst(_ overallFlickerAtPCC: Double,
                                                           pccToUpstreamSystemTransferCoefficient: Double) -> Double {
        
        let overallFlickerAtUSBusPst = overallFlickerAtPCC * pccToUpstreamSystemTransferCoefficient
        return overallFlickerAtUSBusPst
        
    }
    
    internal static func calculateFlickerDueToLoadAtPCCMaxCurrent(_ emissionLimit: Double,
                                                                  flickerDueToLoadAtPCCPst: Double,
                                                                  loadAmpsResultingInDeltaVVPercentAtPCC: Double) -> Double {
        
        let overallFlickerAtPCCMaxCurrent = (emissionLimit * loadAmpsResultingInDeltaVVPercentAtPCC) / flickerDueToLoadAtPCCPst
        return overallFlickerAtPCCMaxCurrent
        
    }
    
    internal static func calculateOverallFlickerAtPCCMaxCurrent(_ maximumGlobalContributionAtPCC: Double,
                                                                overallFlickerAtPCCPst: Double,
                                                                loadAmpsResultingInDeltaVVPercentAtPCC: Double) -> Double {
        
        let flickerDueToLoadAtPCCMaxCurrent = (maximumGlobalContributionAtPCC * loadAmpsResultingInDeltaVVPercentAtPCC) / overallFlickerAtPCCPst
        return flickerDueToLoadAtPCCMaxCurrent
        
    }
    

    
    // MARK: - Sub Calculations
    // MARK: Change Rate
    internal static func calculateNormalizedChangeRate(_ changeRate: Double,
                                                       changeUnit: ChangeUnit) -> Double {
    
        let normalizedChangeRate = changeRate * changeUnit.changeRateAdjustment()
        return normalizedChangeRate
        
    }
    
    fileprivate static func changeRateAOneDataBounds(_ changeUnit: ChangeUnit) -> (lower: Double, upper: Double) {
        
        let lowerBound = Self.aOneTable.first!.x / changeUnit.changeRateAdjustment()
        let upperBound = self.aOneTable.last!.x / changeUnit.changeRateAdjustment()
        
        return (lowerBound, upperBound)
        
    }
    
    fileprivate static func changeRateShapeDataBounds(_ changeUnit: ChangeUnit) -> (lower: Double, upper: Double) {
        
        let lowerBound = Self.ShapeType.shapeDataIndex.first! / changeUnit.changeRateAdjustment()
        let upperBound = Self.ShapeType.shapeDataIndex.last! / changeUnit.changeRateAdjustment()
        
        return (lowerBound, upperBound)
    }

    // MARK: Shape Factor
    internal static func calculateShapeFactor(_ shapeType: ShapeType,
                                              durationOfVoltageChange: Double?,
                                              changeRate: Double?,
                                              changeUnit: ChangeUnit?) -> Double? {
        
        var shapeFactor : Double?
        
            
        if shapeType == .Rectangular ||
        shapeType == .Aperiodic {
            
            shapeFactor = 1.0
        
        } else if shapeType == .Pulse ||
            shapeType == .Ramp ||
            shapeType == .DoublePulse ||
            shapeType == .DoubleRamp {
            
            if let durationOfVoltageChange = durationOfVoltageChange {
                
                shapeFactor = Self.calculateShapeFactorWithDurationOfVoltageChange(durationOfVoltageChange,
                                                                                   shapeTypeData: shapeType.shapeTableData())
                
            }
            
        } else if shapeType == .Sinusoidal ||
            shapeType == .Triangular {
            
            if let changeRate = changeRate,
                let changeUnit = changeUnit {
                
                let normalizedChangeRate = Self.calculateNormalizedChangeRate(changeRate,
                                                                              changeUnit: changeUnit)
                shapeFactor = Self.calculateShapeFactorWithChangeRate(normalizedChangeRate,
                                                                      shapeTypeData: shapeType.shapeTableData())
            }
            
        } else {
            assert(false, "unrecognized shape type! \(shapeType)")
        }
    
           
        
        return shapeFactor
    }
    
    internal static func calculateShapeFactorWithDurationOfVoltageChange(_ durationOfVoltageChange: Double,
                                                                         shapeTypeData: [Point<Double>]) -> Double? {
        
        let interpolatedValue = linearlyInterpolate(durationOfVoltageChange, points: shapeTypeData).first?.y
        return interpolatedValue
        
    }
    
    
    internal static func calculateShapeFactorWithChangeRate(_ normalizedChangeRate: Double,
                                                            shapeTypeData: [Point<Double>]) -> Double? {
        
        let interpolatedValue = linearlyInterpolate(normalizedChangeRate, points: shapeTypeData).first?.y
        return interpolatedValue
        
    }
    
    // MARK: Dpst_1 Calculation
    internal static func calculateDPstOne(_ changeRate: Double,
                                          changeUnit: ChangeUnit) -> Double? {
        
        let normalizedChangeRate = Self.calculateNormalizedChangeRate(changeRate,
                                                                      changeUnit: changeUnit)

            
        let interpolatedValue = linearlyInterpolate(normalizedChangeRate, points: Self.aOneTable).first?.y
        return interpolatedValue
        
    }
}

// MARK: - FlickerLimitProtocol
extension RepetitiveLoadData : FlickerLimitProtocol {
    func flickerLimitsDidChange() {
        self.recalculateOutputParameters()
    }
    
    func flickerLimitsDidReset() {
        self.recalculateOutputParameters()
    }
}
