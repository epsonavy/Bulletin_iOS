//
//  LoginOneViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class LoginOneViewController : UIViewController{
    
    var parentVc: LoginViewController!
    
    @IBOutlet weak var loginTF: FlatTextField!
    @IBOutlet weak var passwordTF: FlatTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVc = self.parentViewController as! LoginViewController
        parentVc.parentMethod()
        
        loginTF.placeholder = "Login ID"
        passwordTF.placeholder = "Password"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
