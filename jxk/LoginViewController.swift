//
//  LoginViewController.swift
//  jxk
//
//  Created by Zachary on 15-7-20.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var textFiled_username: UITextField!
    @IBOutlet weak var textFiled_password: UITextField!
    override func viewDidAppear(animated: Bool) {
        var userDefault = NSUserDefaults.standardUserDefaults()
        let isLogin = userDefault.boolForKey("isLogin")
        println(isLogin)
        
        if isLogin {
            var controller: AnyObject? = storyboard?.instantiateViewControllerWithIdentifier("MainViewController")
            presentViewController(controller as UIViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelLogin(sender: UIBarButtonItem) {
        
        var controller: AnyObject? = storyboard?.instantiateViewControllerWithIdentifier("MainViewController")
        
        presentViewController(controller as UIViewController, animated: true, completion: nil)

    }
    @IBAction func loginByReturn() {
        login()
    }
    
    @IBAction func login() {
        var login = Login()
        if textFiled_password.text == "" || textFiled_username.text == "" {
            let alertView = UIAlertView()
            alertView.title = "邮箱或密码不能为空"
            alertView.addButtonWithTitle("确定")
            alertView.show()
        }
        else {
            login.login(textFiled_username.text, password: textFiled_password.text, handleLoginResult)
        }
    }
    
    private func handleLoginResult(data: NSData!, response: NSURLResponse!, error: NSError!) {
        if error != nil {
            println("\(error)")
        }
        else {
            if let str = NSString(data: data, encoding: NSUTF8StringEncoding) {
                println(str)
            }
        }
    }
}