//
//  LinearInterpolation.swift
//  Flicker
//
//  Created by Anders Melen on 5/20/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import Foundation

// MARK: - Numeric Type Protocol
protocol NumericType : Comparable {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
//    static func %(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
}

extension Double : NumericType { }
extension Float  : NumericType { }
extension Int    : NumericType { }
extension Int8   : NumericType { }
extension Int16  : NumericType { }
extension Int32  : NumericType { }
extension Int64  : NumericType { }
extension UInt   : NumericType { }
extension UInt8  : NumericType { }
extension UInt16 : NumericType { }
extension UInt32 : NumericType { }
extension UInt64 : NumericType { }


// MARK: - Point
struct Point<T> where T: NumericType {
    var x: T
    var y: T
    
    init(x: T, y: T) {
        self.x = x
        self.y = y
    }
}

// MARK: - Linear Interpolation
func linearlyInterpolate<T>(_ interpolationStrideThrough: StrideThrough<T>, points: [Point<T>]) -> [Point<T>] {
    let interpolationIndexArray = arrayFromStrideThrough(interpolationStrideThrough)
    return linearlyInterpolate(interpolationIndexArray, points: points)
}

func linearlyInterpolate<T>(_ interpolation: T, points: [Point<T>]) -> [Point<T>] {
    return linearlyInterpolate([interpolation], points: points)
}

func linearlyInterpolate<T>(_ interpolation: [T], points: [Point<T>]) -> [Point<T>] {
    var interpolatedValues = [Point<T>]()
    
    for interpolationIndex in interpolation {
        if let interpolatedValue = interpolateValue(interpolationIndex, points: points) {
            interpolatedValues.append(interpolatedValue)
        }
    }
    
    return interpolatedValues
}

// MARK: Sub-Functions
private func arrayFromStrideThrough<T>(_ strideThrough: StrideThrough<T>) -> [T] where T: NumericType {
    let sequence = strideThrough.enumerated()
    let arrayValue = sequence.map { (index, element) -> T in
        return element
    }
    
    return arrayValue
}

private func interpolateValue<T>(_ interpolationIndex: T, points: [Point<T>]) -> Point<T>? {
    if let bounds = findDomainBoundsFromInterpolationXValue(interpolationIndex, points: points) {
        
        let percent = calculateBoundDomainPercentage(interpolationIndex, bound: bounds)
        let interpolatedValue = mapValue(percent, bounds: bounds)
        
//         print("interp-domain: \(interpolationIndex) - domain: \(bounds.0.x),\(bounds.1.x) - range: \(bounds.0.y),\(bounds.1.y) - percent: \(percent) - value: \(interpolatedValue)")
        
        return Point(x: interpolationIndex, y: interpolatedValue)
    } else {
//        assert(false, "invalid bounds for \(interpolationIndex)")
        return nil
    }
}

private func calculateBoundDomainPercentage<T>(_ value: T, bound: (lowerBound : Point<T>, upperBound : Point<T>)) -> T {
    if bound.lowerBound.x == bound.upperBound.x {
        return T(0)
    } else {
        let percent = (value - bound.lowerBound.x) / (bound.upperBound.x - bound.lowerBound.x)
        return percent
    }
}

private func findDomainBoundsFromInterpolationXValue<T>(_ interpolationIndex: T, points: [Point<T>]) -> (lowerBound : Point<T>, upperBound : Point<T>)? {
    
    
    // Out of X domain bounds
    if let first = points.first {
        if interpolationIndex < first.x {
            return nil
        }
    } else {
        return nil
    }
    
    if let last = points.last {
        if interpolationIndex > last.x {
            return nil
        }
    } else {
        return nil
    }
    
    
    // Find X domain bounds
    var lowerBound : Point<T>?
    var lowerBoundIndex : Int!
    var upperBound : Point<T>?
    
    for i in 0 ... points.count {
        
        let point = points[i]
        
        if interpolationIndex == point.x {
            return (point, point)
        }
        
        if interpolationIndex < point.x {
            lowerBoundIndex = i - 1
            let lastPoint = points[lowerBoundIndex]
            lowerBound = lastPoint
            break
        }
    }
    
    
    upperBound = points[lowerBoundIndex + 1]
    return (lowerBound!, upperBound!)
}

private func calculateBoundPercent<T>(_ value: T, domainBound: (lower: Int, upper: Int)) -> T where T: NumericType {
    let percent = (value - T(domainBound.lower)) / T(domainBound.upper - domainBound.lower)
    assert(percent >= T(0) && percent <= T(1), "percent not in value rage [0,1]... \(percent)")
    return percent
}

private func mapValue<T>(_ percent: T, bounds: (lowerBound: Point<T>, upperBound: Point<T>)) -> T {
    let mappedValue = bounds.lowerBound.y + (bounds.upperBound.y - bounds.lowerBound.y) * percent
    return mappedValue
}
