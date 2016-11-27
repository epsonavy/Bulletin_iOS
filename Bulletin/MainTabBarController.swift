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
        activityVc = self.viewControllers![3] as! UINavigationController //shit..
        settingsVc = self.viewControllers![4] as! SettingsViewController
        
        //hideTabBarAnimated(false)
    }
    

    
 
    
    /*
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideTabBarAnimated(true)
    }

    
    func swipeAction(gesture: UIGestureRecognizer){
        let swipeRecognizer = gesture as! UISwipeGestureRecognizer
            if swipeRecognizer.direction == UISwipeGestureRecognizerDirection.Up {
                hideTabBarAnimated(true)
            }else if swipeRecognizer.direction == UISwipeGestureRecognizerDirection.Down {
                hideTabBarAnimated(false)
            }
    }*/

    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
    }

    /*
    func hideChildViewControllersTab(hide: Bool){
        if hide {
            homeVc.hideNavigationBar(hide);
        } else {
            homeVc.hideNavigationBar(hide)
        }
    }

    func hideTabBarAnimated(hide:Bool) {
        if hide{
            homeVc.automaticallyAdjustsScrollViewInsets = true
            UIView.animateWithDuration(0.3, animations: {
                  self.homeVc.edgesForExtendedLayout = UIRectEdge.Bottom
            })
          
            homeVc.extendedLayoutIncludesOpaqueBars = false
        }else{
            homeVc.automaticallyAdjustsScrollViewInsets = true
            UIView.animateWithDuration(0.3, animations: {
                self.homeVc.edgesForExtendedLayout = UIRectEdge.None
            })
            homeVc.extendedLayoutIncludesOpaqueBars = false
        }

        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: {
                if hide {
                    self.tabBar.transform = CGAffineTransformMakeTranslation(0, 50)
                } else {
                    self.tabBar.transform = CGAffineTransformIdentity
      
                }
        }, completion: nil)
        
        hideChildViewControllersTab(hide)
    }*/
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}
