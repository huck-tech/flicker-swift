//
//  UIColor+Methods.swift
//  Flicker
//
//  Created by Anders Melen on 6/8/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

extension UIColor {
    static func errorRedColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 131.0/255.0, blue: 131.0/255.0, alpha: 1.0)
    }
    
    static func validGreenColor() -> UIColor {
        return UIColor(red: 187.0/255.0, green: 255.0/255.0, blue: 162.0/255.0, alpha: 1.0)
    }
    
    static func lightBlueColor() -> UIColor {
        return UIColor(red: 83.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    static func limitsYellowColor() -> UIColor {
        return UIColor(red: 248.0/255.0, green: 253.0/255.0, blue: 107.0/255.0, alpha: 1.0)
    }
    
    static func darkNavyBlueColor() -> UIColor {
        return UIColor(red: 61.0/255.0, green: 60.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    }
    
    static func lightNavyBlueColor() -> UIColor {
        return UIColor(red: 72.0/255.0, green: 70.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    }
    
    static func lightWhiteColor() -> UIColor {
        return UIColor(red: 149.0/255.0, green: 152.0/255.0, blue: 154.0/255.0, alpha: 1.0)
    }
    
    static func flickerLightBlue() -> UIColor {
        return UIColor(red: 63.0/255.0, green: 195/255.0, blue: 253.0/255.0, alpha: 1.0)
    }
}
