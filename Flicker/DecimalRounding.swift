//
//  DecimalRounding.swift
//  Flicker
//
//  Created by Anders Melen on 5/27/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import Foundation

extension Double {
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let temp = self * divisor
        let tempTwo = temp.rounded()
        let tempThree = tempTwo / divisor
        return tempThree
    }
}
