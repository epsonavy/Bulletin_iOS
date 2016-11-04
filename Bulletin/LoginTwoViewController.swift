//
//  LoginTwoViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class LoginTwoViewController : UIViewController{
    
    var parentVc : LoginViewController!
    
    @IBOutlet weak var schoolImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVc = self.parentViewController as! LoginViewController
        
        schoolImage.layer.cornerRadius = schoolImage.frame.size.width / 2
        schoolImage.clipsToBounds = true
        schoolImage.layer.borderWidth = 4
        schoolImage.layer.borderColor = Singleton.buttonBgColor.CGColor
        
        locationLabel.text = "You are at San Jose State University ^_^"
        locationLabel.textColor = Singleton.buttonBgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
