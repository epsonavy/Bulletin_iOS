//
//  LoginViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, UIScrollViewDelegate{
    var orangeBarView : OrangeBarView!
    
    @IBOutlet weak var nextButton: FlatButton!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    var currentPosition : Int = 0
    
    @IBAction func nextButtonTap(sender: AnyObject) {
        currentPosition = currentPosition + 1
        if(currentPosition >= selectedViews.count ){
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
            self.presentViewController(vc, animated: true, completion: nil)
            currentPosition = 0
        }
        selectPosition(currentPosition)
        
    }
    @IBOutlet weak var selectedOne: CircleLabelView!
    @IBOutlet weak var selectedTwo: CircleLabelView!
    @IBOutlet weak var selectedThree: CircleLabelView!

    
    @IBOutlet weak var unselectedOne: UILabel!
    @IBOutlet weak var unselectedTwo: UILabel!
    @IBOutlet weak var unselectedThree: UILabel!
    
    var selectedViews = Array<CircleLabelView!>()
    var unselectedViews = Array<UILabel!>()
    
    @IBOutlet weak var grayBarHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad(){
        super.viewDidLoad();
        
        initBars()
        addViewsToArray()
        addPagesToContentScrollView()
        //kevin: use the singleton to store everything between pages 1-3. however, the finalization will be taken here.
        
        
        
        selectPosition(currentPosition)
        
    }
    
    //here is an example of child calling a parent method. check login pages to see.
    func parentMethod(){
        print("A method was called from child")
        
    
    }
    
    //kevin: TODO, this will allow child view controllers to disable the next button if their fields are
    //incomplete..
    //ex: missing username, password
    func disableNext(){
        
    }
    func enableNext(){
        
    }
    func addPagesToContentScrollView(){
        contentScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width * 3, height: contentScrollView.frame.height)
        
        let one = self.storyboard?.instantiateViewControllerWithIdentifier("LoginOneViewController") as! LoginOneViewController
        
        let two = self.storyboard?.instantiateViewControllerWithIdentifier("LoginTwoViewController") as! LoginTwoViewController
        
        let three = self.storyboard?.instantiateViewControllerWithIdentifier("LoginThreeViewController") as! LoginThreeViewController
        
        self.addChildViewController(one)
        
        self.addChildViewController(two)
        
        self.addChildViewController(three)
        
        one.didMoveToParentViewController(self)
        two.didMoveToParentViewController(self)
        three.didMoveToParentViewController(self)
        
        one.view.frame = CGRect(x: 0, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
    
        two.view.frame = CGRect(x: UIScreen.mainScreen().bounds.width, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        
        three.view.frame = CGRect(x: UIScreen.mainScreen().bounds.width * 2, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        
       
        contentScrollView.pagingEnabled = true
        
        
        contentScrollView.scrollEnabled = false
        
        one.view.frame.origin = CGPoint(x: 0, y:0)
        
        contentScrollView.addSubview(one.view)
        contentScrollView.addSubview(two.view)
        contentScrollView.addSubview(three.view)
        
    }
    func initBars(){
        let orangeBarWidth = self.view.frame.width / 3
        let orangeBarHeight: CGFloat = 2

        orangeBarView = OrangeBarView(frame: CGRect(x: 0, y: grayBarHeightConstraint.constant - orangeBarHeight, width: orangeBarWidth, height: orangeBarHeight))
        self.view.addSubview(orangeBarView)
 
    }
    func addViewsToArray(){
        selectedViews.append(selectedOne)
        selectedViews.append(selectedTwo)
        selectedViews.append(selectedThree)
        
        unselectedViews.append(unselectedOne)
        unselectedViews.append(unselectedTwo)
        unselectedViews.append(unselectedThree)
    }
    override func viewDidAppear(animated: Bool) {
                self.view.bringSubviewToFront(orangeBarView)
        
    }
    func selectPosition(position: Int){
        if(position >= 0 && position < selectedViews.count){
            for i in 0...selectedViews.count - 1{
                if(i == position){
                    UIView.animateWithDuration(0.5, animations: {
                        self.selectedViews[i].alpha = 1
                    })
                }else{
                    UIView.animateWithDuration(0.5, animations: {
                        self.selectedViews[i].alpha = 0
                        })
                    
                }
            }
            for i in 0...unselectedViews.count - 1{
                if(i == position){
                    UIView.animateWithDuration(0.5, animations: {
                        self.unselectedViews[i].alpha = 0
                    })
                }else{
                    UIView.animateWithDuration(0.5, animations: {
                        self.unselectedViews[i].alpha = 1
                        })
                    
                }
            }
            contentScrollView.setContentOffset(CGPoint(x: UIScreen.mainScreen().bounds.width * CGFloat(position), y: 0), animated: true)
            
            moveOrangeBar(position)
        }
       
    }
    
    func moveOrangeBar(position : Int){
        UIView.animateWithDuration(NSTimeInterval(1), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: [], animations: {
            self.orangeBarView.frame.origin.x = (self.view.frame.width / 3) * CGFloat(position)
            
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
