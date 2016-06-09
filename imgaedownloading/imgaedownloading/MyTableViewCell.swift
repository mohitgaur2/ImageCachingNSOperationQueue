//
//  MyTableViewCell.swift
//  imgaedownloading
//
//  Created by Mohit on 08/06/16.
//  Copyright © 2016 Mohit. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configurecell(data: NSData?){
        self.activityIndicator.startAnimating()

        if let _ = data{
           self.imageView1?.image = UIImage(data: data!)
           self.activityIndicator.stopAnimating()
           self.activityIndicator.hidden = true
           self.activityIndicator.removeFromSuperview()
            
        }else{
            self.activityIndicator.hidden = false
        }
        
    }

}
