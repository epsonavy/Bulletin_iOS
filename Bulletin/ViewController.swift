//
//  ViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var startButton: FlatButton!
    @IBOutlet weak var startButtonVertical: NSLayoutConstraint!
    @IBAction func startTap(sender: AnyObject) {
        

        UIView.animateWithDuration(NSTimeInterval(5), delay: 0, options: .CurveEaseIn, animations: {
            self.startButtonVertical.constant = -self.startButton.frame.height
            self.startButton.layoutIfNeeded()
            }, completion: {
                (finished: Bool) -> Void in
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.presentViewController(vc, animated: true, completion: nil)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundBlurEffect = UIBlurEffect(style: .Light)
        
        let backgroundBlurView = UIVisualEffectView(effect: backgroundBlurEffect)
        
        backgroundBlurView.translatesAutoresizingMaskIntoConstraints = true
        
        backgroundBlurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
      //  backgroundImageView.addSubview(backgroundBlurView)
        
        
        self.view.bringSubviewToFront(self.startButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

