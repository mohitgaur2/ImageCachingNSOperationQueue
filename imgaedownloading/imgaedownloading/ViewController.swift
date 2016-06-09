//
//  ViewController.swift
//  imgaedownloading
//
//  Created by Mohit on 08/06/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var imageURLArray: [String]? = [String]()
    @IBOutlet var tableView: UITableView!
    let operationQ = NSOperationQueue()
    let cache = NSCache()
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
        // Dispose of any resources that can be recreated.
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
        operationQ.addOperationWithBlock {
            
            let url = NSURL(string:self.imageURLArray![indexPath.row])
            var data: NSData?
            if let cachedData = self.cache.objectForKey(url!){
                
               data = cachedData as? NSData
                
            }else{
                cell?.activityIndicator.startAnimating()

                if let downloadedData = NSData(contentsOfURL: url!){
                    self.cache.setObject(downloadedData, forKey: url!)
                    data = downloadedData
                }

            }
            NSOperationQueue.mainQueue().addOperationWithBlock({
                cell?.configurecell(data)
                cell?.name.text = "Row \(indexPath.row)"
            })
        }
        
        
        return cell!
        
    }
    
    

    
    
}

