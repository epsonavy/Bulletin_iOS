//
//  MainViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController, UITabBarControllerDelegate, UIScrollViewDelegate{
    
    var homeVc : UINavigationController! // =>HomeViewController!
    var messageVc : UINavigationController! // =>MessageViewController!
    var postVc : UINavigationController! // => PostViewController!
    var activityVc : UINavigationController!
    var settingsVc : SettingsViewController!
    
    let singleton = Singleton.sharedInstance
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.blackColor()
        self.tabBar.barTintColor = UIColor(red:0.985, green:0.985, blue:0.985, alpha: 1.0)


    
        homeVc = self.viewControllers![0] as! UINavigationController // =>HomeViewController
        messageVc = self.viewControllers![1] as! UINavigationController // =>MessageViewController
        postVc = self.viewControllers![2] as! UINavigationController // => PostViewController
        activityVc = self.viewControllers![3] as! UINavigationController
        settingsVc = self.viewControllers![4] as! SettingsViewController
 
    }
    
    
    
 


    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
    }

    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}
