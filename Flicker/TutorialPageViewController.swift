//
//  TutorialPageViewController.swift
//  Flicker
//
//  Created by Anders Melen on 6/7/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    fileprivate typealias `Self` = TutorialPageViewController
    
    static let tutorialImages = ["Welcome",
                                 "FlickerLimitsTutorialImage",
                                 "HelpButtonTutorialImage",
                                 "MissingInputsTutorialImage",
                                 "ReferenceDiagramTutorialImage",
                                 "ValidFlickerLimitsTutorialImage"]
    
    fileprivate var pageViewControllers = [TutorialImageViewController]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIPageControl.appearance().tintColor = UIColor.orange
        UIPageControl.appearance().backgroundColor = UIColor.clear
        
        self.createTutorialViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.landscapeLeft &&
            UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.landscapeRight {

            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }

        
        self.navigationController?.isNavigationBarHidden = true
        
//        let orientation = UIInterfaceOrientation.LandscapeLeft.rawValue
//        UIDevice.currentDevice().setValue(orientation, forKey: "orientation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuration
    func createTutorialViewControllers() {
        
        self.dataSource = self
        
        for i in 0 ..< Self.tutorialImages.count {
            
            let tutorialImageAsset = Self.tutorialImages[i]
            
            let imageViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorialImageViewControllerStoryboardID") as! TutorialImageViewController
            
            imageViewController.configure(UIImage(named: tutorialImageAsset)!, index: i)
            imageViewController.tutorialImageViewControllerDelegate = self
            
            self.pageViewControllers.append(imageViewController)
        }
        
        
        
        self.setViewControllers([self.pageViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Orientation
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
}

extension TutorialPageViewController : UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return Self.tutorialImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! TutorialImageViewController).index
        
        if currentIndex! > 0 {
            
            let nextViewController = self.pageViewControllers[currentIndex! - 1]
            return nextViewController
            
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! TutorialImageViewController).index
        
        if currentIndex! < Self.tutorialImages.count - 1 {
            
            let nextViewController = self.pageViewControllers[currentIndex! + 1]
            return nextViewController
            
        } else {
            return nil
        }
    }
}

extension TutorialPageViewController : TutorialImageViewControllerProtocol {
    func tutorialCloseButtonPressed() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
