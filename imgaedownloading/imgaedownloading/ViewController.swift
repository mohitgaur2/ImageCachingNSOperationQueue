//
//  ViewController.swift
//  imgaedownloading
//
//  Created by Mohit on 08/06/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView! //Tableview
    
    var imageURLArray: [String]? = [String]() //For holding image URls
    let operationQ = NSOperationQueue() // OperationQueue instantiated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let plistPath = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") else{
            return
        }
        imageURLArray = NSArray(contentsOfFile: plistPath) as? [String]
        
        //Setting up the maximum concurrency operation count, how many thread will be created at the time of network request for downloading the image data.
        operationQ.maxConcurrentOperationCount = 4
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
      let imageUrl = NSURL(string:self.imageURLArray![indexPath.row])

        if let cachedData = cache.objectForKey(imageUrl!){
            cell!.configurecell(cachedData as? NSData)
            cell?.name.text = "Row \(indexPath.row)"
            
        }else{
            cell?.activityIndicator.startAnimating()
            
            //Added operaion in NSOperationQueue with block
            operationQ.addOperationWithBlock({
                if let downloadedData = NSData(contentsOfURL: imageUrl!){
                    
                    //Caching of image data for performance improvment & save network/server calls
                    cache.setObject(downloadedData, forKey: imageUrl!)
                    
                    //MainQueue for perfomring UI operation/updatation
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        cell!.configurecell(downloadedData)
                        cell?.name.text = "Row \(indexPath.row)"
                    })
                }
            })
           
        }
        return cell!
    }
    
}

