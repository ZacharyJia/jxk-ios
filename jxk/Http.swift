//
//  Http.swift
//  jxk
//
//  Created by Zachary on 15-7-20.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import Foundation

class HttpRequest {
    
    class func POST(url: String, params: Dictionary<String, String>, handler: (NSData!, NSURLResponse!, NSError!)->Void){
        let requestUrl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = "POST"
        var postString = ""
        for (key, value) in params {
            postString += key + "=" + value + "&"
        }
        
        if params.count > 0 {
            postString.removeRange(Range(start: advance(postString.endIndex, -1), end: postString.endIndex))
        }

        println(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: handler)
        
        task.resume()
    }
}
