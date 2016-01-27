//
//  VTAWebViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 1/26/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var webString: String!
    var titleString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {        
        navigationTitle.title = titleString
        
        let URL = NSURL(string: webString!)
        let request = NSURLRequest(URL: URL!)
        webView.loadRequest(request)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
