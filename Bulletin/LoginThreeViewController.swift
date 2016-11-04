//
//  LoginThreeViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class LoginThreeViewController : UIViewController{
    
    var parentVc : LoginViewController!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVc = self.parentViewController as! LoginViewController
        
        messageLabel.text = "Please confirm your email ^_^."
        messageLabel.textColor = Singleton.buttonBgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
