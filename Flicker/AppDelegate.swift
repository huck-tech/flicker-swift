//
//  AppDelegate.swift
//  Flicker
//
//  Created by Anders Melen on 5/12/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Accessors
    static func sharedAppDelegate() -> AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    static func rootViewController() -> RootViewController {
        return ((AppDelegate.sharedAppDelegate().window?.rootViewController as! UINavigationController).viewControllers.first as! RootViewController)
    }
    
    static func rootNavigationController() -> RootNavigationViewController {
        return AppDelegate.sharedAppDelegate().window?.rootViewController as! RootNavigationViewController
    }
    
    static func problemsTabBarController() -> ProblemsTabBarController? {
        for childVC in AppDelegate.rootViewController().childViewControllers {
            if let problemTabBarController = childVC as? ProblemsTabBarController {
                return problemTabBarController
            }
        }
        
        assert(false, "failed to find problems tab bar view controller")
        return nil
    }

    // MARK: - App Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

#if FABRIC
		print ("Fabric and Crashlytics included")
        Fabric.with([Crashlytics.self])
#endif

        UIApplication.shared.statusBarStyle = .lightContent
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.flickerLightBlue()], for: .selected)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

