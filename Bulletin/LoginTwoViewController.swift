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
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVc = self.parentViewController as! LoginViewController
        
        locationLabel.text = "You are at San Jose State University ^_^"
        locationLabel.textColor = Singleton.sharedInstance.mainThemeColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
