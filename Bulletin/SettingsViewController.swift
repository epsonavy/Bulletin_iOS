//
//  SettingsViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//


import UIKit

class SettingsViewController : UIViewController{
    
    @IBOutlet weak var firstName: FlatTextField!
    @IBOutlet weak var lastName: FlatTextField!
    @IBOutlet weak var email: FlatTextField!
    @IBOutlet weak var phoneNum: FlatTextField!
    override func viewDidLoad(){
        super.viewDidLoad()
        firstName.placeholder = "First Name"
        lastName.placeholder = "Last Name"
        email.placeholder = "Jay@sjsu.edu"
        phoneNum.placeholder = "(123) 456 7890"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
