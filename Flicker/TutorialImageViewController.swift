 //
//  TutorialImageViewController.swift
//  Flicker
//
//  Created by Anders Melen on 6/7/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

 protocol TutorialImageViewControllerProtocol {
    func tutorialCloseButtonPressed()
 }
 
class TutorialImageViewController: UIViewController {

    @IBOutlet weak var swipeHelpImageView: UIImageView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    
    fileprivate var image: UIImage!
    
    fileprivate var showingShowingSwipeHelp = false
    
    var tutorialImageViewControllerDelegate : TutorialImageViewControllerProtocol?
    
    var index : Int!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.swipeHelpImageView.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Swipe Help
    func showSwipeHelpImageView() {
        
        self.showingShowingSwipeHelp = true
        
        let hideClosure : ()->() = {
            
            UIView.transition(with: self.swipeHelpImageView,
                                      duration: 0.2,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.swipeHelpImageView.isHidden = true
            }) { (completed) in
                
                self.showingShowingSwipeHelp = false
            }
        }
        
        UIView.transition(with: self.swipeHelpImageView,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: {
            self.swipeHelpImageView.isHidden = false
            }) { (completed) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: hideClosure)
        }
    }
    
    // MARK: - Configuration
    func configure(_ image: UIImage, index: Int) {
        self.image = image
        self.index = index
    }
    
    // MARK: - Button Callbacks
    
    @IBAction func backgroundButtonPressed(_ sender: UIButton) {
        if showingShowingSwipeHelp == false {
            self.showSwipeHelpImageView()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
         self.tutorialImageViewControllerDelegate?.tutorialCloseButtonPressed()
    }

    // MARK: - Orientation
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeLeft
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
