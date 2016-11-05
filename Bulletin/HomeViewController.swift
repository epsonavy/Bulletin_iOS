//
//  HomeViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class HomeViewController : UIViewController{
    
    @IBOutlet weak var navigationBar: GrayBarView!
    @IBOutlet weak var navigationBarTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("yes")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideNavigationBar(hide: Bool){
        if (navigationBar == nil){
            print("navigationBar is nil")
        }
    }
}
