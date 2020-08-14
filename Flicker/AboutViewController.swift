//
//  AboutViewController.swift
//  Flicker
//
//  Created by Anders Melen on 6/6/16.
//  Copyright © 2016 Electric Power Research Institute, Inc.				
//
//  EPRI reserves all rights in the Program as delivered.  The Program or any portion thereof may not be reproduced in any form whatsoever except as provided by license without the written consent of EPRI.  A license under EPRI's rights in the Program may be available directly from EPRI.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    static var STORYBOARD_ID = "aboutViewControllerStoryboardID"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aboutHTMLPath = Bundle.main.path(forResource: "about", ofType: "html")!
        var aboutHTML = String.init(data: try! Data.init(contentsOf: URL(fileURLWithPath: aboutHTMLPath)), encoding: String.Encoding.utf8)!
        
        aboutHTML = aboutHTML.replacingOccurrences(of: "[[VERSION_BUILD]]", with: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        
        self.webView.loadHTMLString(aboutHTML, baseURL: Bundle.main.bundleURL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
