//
//  NSUserDefaultSyncable.swift
//  Flicker
//
//  Created by Anders Melen on 5/19/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class NSUserDefaultSyncable {
    
    static func saveObjectToNSUserDefaults(_ key: String, value: AnyObject?, defaults: UserDefaults = UserDefaults.standard) {
//        NSLog("Saving \(value) to key \(key)")
        
        if let value = value {
            defaults.set(value, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
        
        defaults.synchronize()
    }
    
    static func loadObjectFromNSUserDefaults<T>(_ key: String, defaults: UserDefaults = UserDefaults.standard) -> T? {
        let result = defaults.object(forKey: key)
//        NSLog("Loaded \(result) from key \(key)")
        return result as? T
    }
}
