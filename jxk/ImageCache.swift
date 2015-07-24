//
//  ImageCache.swift
//  jxk
//
//  Created by Zachary on 15-7-23.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    //传递一个uiimageView，和图片路径，设置背景，异步
    class func setImagesViewData(newsImageView:UIImageView,imageString:String){
        
        var catePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.AllDomainsMask, true)

        var cateImagesUrl:NSURL = NSURL(fileURLWithPath: "\(catePath[0])/\(imageString.md5)")!//获取缓存MD5路径
        //println(cateFileObj.getCacheImagesDataByUrl(imagesName))
        if let cateReadData:NSData  = NSData(contentsOfURL: cateImagesUrl) {//缓存存在直接加载
            newsImageView.image = UIImage(data: cateReadData);
        }else{
            newsImageView.image = UIImage(named: "load.jpg");//默认图片
            //异步加载图片，开一个线程
            NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: imageString)!), queue: NSOperationQueue()) { (resp:NSURLResponse!, imageData:NSData!, error:NSError!) -> Void in
                if let e = error {
                    println("连接网络失败1:\(imageString)");
                }else{
                    //加载完了回主线程修改图片
                    if let endImageData = imageData{
                        dispatch_sync(dispatch_get_main_queue(),{ () -> Void in
                            newsImageView.image = UIImage(data: endImageData);
                        })
                        //写入缓存文件
                        endImageData.writeToURL(cateImagesUrl, atomically: true)
                    }
                }
            }
        }
    }
}