//
//  DetailViewController.swift
//  jxk
//
//  Created by Zachary on 15-7-24.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    let url: String = "http://bjtucit.sinaapp.com/api/getArticle.php?id="
    var articleID: String = ""
    var articleTitle: String = ""
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBAction func close(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        
        modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal

        
        viewTitle.title = articleTitle
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url + articleID)!))
    }

    
    @IBAction func swipeRight(sender: AnyObject) {
        println("swipeRight")
        println("\(webView.request?.URL.absoluteString)")
        if (webView.request?.URL.absoluteString! == (url + articleID)) {
            //close
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            webView.goBack()
        }
    }
}