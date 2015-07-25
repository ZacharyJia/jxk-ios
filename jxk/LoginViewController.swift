//
//  LoginViewController.swift
//  jxk
//
//  Created by Zachary on 15-7-20.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFiled_username: UITextField!
    @IBOutlet weak var textFiled_password: UITextField!
    override func viewDidAppear(animated: Bool) {
        
        textFiled_password.delegate = self
        
        var userDefault = NSUserDefaults.standardUserDefaults()
        let username = userDefault.stringForKey("username")
        let password = userDefault.stringForKey("password")
        
        if username != nil && password != nil {
            var login = Login()
            login.login(username!, password: password!.md5, handleLoginResult)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        login()
        return true
    }
    
    
    @IBAction func cancelLogin(sender: UIBarButtonItem) {
        
        var controller: AnyObject? = storyboard?.instantiateViewControllerWithIdentifier("MainViewController")
        
        presentViewController(controller as UIViewController, animated: true, completion: nil)

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
            login.login(textFiled_username.text, password: textFiled_password.text.md5, handleLoginResult)
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
            
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
            
            let status = json?.objectForKey("status") as String
            if status == "success" {
                let username = json?.objectForKey("username") as String
                let studentID = json?.objectForKey("studentID") as String
                let tag = json?.objectForKey("tag") as String
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(username, forKey: "nickname")
                userDefault.setObject(studentID, forKey: "studentID")
                userDefault.setObject(tag, forKey: "tag")
                
                dispatch_async(dispatch_get_main_queue(), {
                    let controller: AnyObject? = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController")
                    
                    self.presentViewController(controller as UIViewController, animated: true, completion: nil)
                })
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), {
                    let alertView = UIAlertView()
                    alertView.title = "邮箱或密码错误，请重新输入"
                    alertView.addButtonWithTitle("确定")
                    alertView.show()
                })
            }
        }
    }
    
    
}