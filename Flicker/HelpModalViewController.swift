//
//  HelpModalViewController.swift
//  Flicker
//
//  Created by Anders Melen on 5/19/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit
import MBProgressHUD

class HelpModalViewController: UIViewController {

    @IBOutlet var backgroundButton: UIButton!
    @IBOutlet var blurView: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var titleLabel: UILabel!
    
    static var sharedInstance : HelpModalViewController! {
        let childViewControllers = AppDelegate.rootViewController().childViewControllers
        for childVC in childViewControllers {
            if childVC.isKind(of: HelpModalViewController.self) {
                return childVC as? HelpModalViewController
            }
        }
        assert(false, "could not find HelpModalViewController!")
        return HelpModalViewController()
    }
    
    func configureWebViewWithPDF(_ pdfURL: URL, title: String) {
        let request = URLRequest(url: pdfURL)
        self.webView.loadRequest(request)
        
        self.titleLabel.text = title
        
        let blurImage = AppDelegate.rootNavigationController().getBackgroundBlurImage()
        self.blurView.setBackgroundImage(blurImage, for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		
		MBProgressHUD.hide (for: self.view, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.webView.scalesPageToFit = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Buttons
    @IBAction func backgroundButtonPressed(_ sender: UIButton) {
        AppDelegate.rootViewController().hideHelpModal()
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

extension HelpModalViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        progress.mode = .indeterminate
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
