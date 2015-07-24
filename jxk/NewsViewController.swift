//
//  FirstViewController.swift
//  jxk
//
//  Created by Zachary on 15-7-20.
//  Copyright (c) 2015年 bjtu. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PZPullToRefreshDelegate {
    
    var selectedSegment = 0;

    @IBOutlet weak var tableView: UITableView!
    
    var arrNew: Array<Dictionary<String, String>> = []
    var arrHot: Array<Dictionary<String, String>> = []
    var arrColumn: Array<Dictionary<String, String>> = []
    
    var refreshHeaderView: PZPullToRefreshView?
    
    /*
     * 切换segment
     */
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        selectedSegment = sender.selectedSegmentIndex
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.r

        //设置tableView的delegate和dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        
        //设置下拉刷新
        if refreshHeaderView == nil {
            var view = PZPullToRefreshView(frame: CGRectMake(0, 0 - tableView.bounds.size.height, tableView.bounds.size.width, tableView.bounds.size.height))
            view.delegate = self
            tableView.addSubview(view)
            refreshHeaderView = view
        }
        
        //加载数据
        HttpRequest.POST("http://bjtucit.sinaapp.com/api/getNewest.php?offset=0", params: Dictionary<String, String>(), handler: processNewest)
    }
    
    
    /*
     * 获取数量
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case 0: return arrNew.count
        case 1: return arrHot.count
        case 2: return arrColumn.count
        default: return 0;
        }
    }
    
    
    /*
     * 实现cell的加载
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier("cell")
        
        let image = cell?.viewWithTag(1) as UIImageView
        let label_column = cell?.viewWithTag(2) as UILabel
        let label_title = cell?.viewWithTag(3) as UILabel
        let label_content = cell?.viewWithTag(4) as UILabel
        
        switch selectedSegment {
        case 0:
            label_column.text = arrNew[indexPath.item]["column"]
            label_title.text = arrNew[indexPath.item]["title"]
            label_content.text = arrNew[indexPath.item]["content"]
            ImageCache.setImagesViewData(image, imageString: arrNew[indexPath.item]["image"]!)
            
        case 1:break
        case 2:break
        default:break
        }
        
        (cell as UITableViewCell).separatorInset = UIEdgeInsetsZero
        (cell as UITableViewCell).layoutMargins = UIEdgeInsetsZero
        
        
        return cell as UITableViewCell
    }
    
    /*
     * 选中选项
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //处理最新数据的返回消息
    func processNewest(data: NSData!, response: NSURLResponse!, error: NSError?) {
        
        if (error != nil) {
            println("\(error)")
            
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertView()
                alert.title = "无法连接网络，请稍后再试"
                alert.addButtonWithTitle("确定")
                alert.show()
            })
        }
        else {
        
            arrNew.removeAll(keepCapacity: false)
            var str = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(str)
            
            var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
            var titles = json?.objectForKey("titles") as NSArray
            var ids = json?.objectForKey("ids") as NSArray
            var images = json?.objectForKey("images") as NSArray
            
            var columns = json?.objectForKey("columns") as NSArray
            var contents = json?.objectForKey("contents") as NSArray
            
            
            var i: Int
            for i = 0; i < titles.count; i++ {
                var dic = Dictionary<String, String>()
                dic["title"] = titles[i] as? String
                dic["id"] = ids[i] as? String
                dic["image"] = images[i] as? String
                dic["column"] = columns[i] as? String
                dic["content"] = contents[i] as? String
                arrNew.append(dic)
            }
            
            dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
            
        }
        refreshHeaderView?.isLoading = false
        refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)

        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
    }

    
    func pullToRefreshDidTrigger(view: PZPullToRefreshView) {
        refreshHeaderView?.isLoading = true
        HttpRequest.POST("http://bjtucit.sinaapp.com/api/getNewest.php?offset=0", params: Dictionary<String, String>(), handler: processNewest)
    }
    
    func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate {
        return NSDate()
    }
}
