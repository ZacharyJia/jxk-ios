//
//  Login.swift
//  jxk
//
//  Created by Zachary on 15-7-20.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import Foundation

class Login {
    func login(username : String, password: String, handler: (NSData!, NSURLResponse!, NSError!)->Void) {
        var params = Dictionary<String, String>()
        params.updateValue(username, forKey: "username")
        params.updateValue(password, forKey: "password")
        HttpRequest.POST("http://bjtucit.sinaapp.com/api/login.php", params: params, handler: handler)
    }
    
    //TODO 检测用户名密码是否合法，是否存在sql注入等 使用正则检验
    private func checkValidation(username : String, password : String) -> Bool {
        return true;
    }
}