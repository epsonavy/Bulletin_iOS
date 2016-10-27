//
//  LoginTwoViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class LoginTwoViewController : UIViewController{
    
    var parentVc : LoginViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVc = self.parentViewController as! LoginViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}