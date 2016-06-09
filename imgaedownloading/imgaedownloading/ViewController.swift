//
//  ViewController.swift
//  imgaedownloading
//
//  Created by Mohit on 08/06/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var imageURLArray: [String]? = [String]() //For holding image URls
    @IBOutlet var tableView: UITableView! //Tableview
    let operationQ = NSOperationQueue() // OperationQueue instantiated
    let cache = NSCache() // For Cahcing the image data corrosponding to server url
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let plistPath = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") else{
            return
        }
        imageURLArray = NSArray(contentsOfFile: plistPath) as? [String]
        operationQ.maxConcurrentOperationCount = 10
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (imageURLArray?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MyTableViewCell", forIndexPath: indexPath) as? MyTableViewCell
        
        //Addning operation in NSOperationQueue
        operationQ.addOperationWithBlock {
            
            //Fetching URL from arryay
            let imageUrl = NSURL(string:self.imageURLArray![indexPath.row])
            var data: NSData?
            //Caching of image data for performance improvment & save network/server calls
            if let cachedData = self.cache.objectForKey(imageUrl!){
                
                data = cachedData as? NSData
                
            }else{
                cell?.activityIndicator.startAnimating()
                
                if let downloadedData = NSData(contentsOfURL: imageUrl!){
                    self.cache.setObject(downloadedData, forKey: imageUrl!)
                    data = downloadedData
                }
                
            }
            
            //MainQueue for perfomring UI operation/updatation
            NSOperationQueue.mainQueue().addOperationWithBlock({
                cell?.configurecell(data)
                cell?.name.text = "Row \(indexPath.row)"
            })
        }
        return cell!
    }
    
    
    
    
    
}

