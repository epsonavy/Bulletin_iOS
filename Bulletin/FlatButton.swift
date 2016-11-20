//
//  FlatButton.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

@IBDesignable class FlatButton : UIButton{
    @IBInspectable var bounceScale: NSNumber?{
        didSet{
            addScalingEvents()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 1
        self.layer.backgroundColor = UIColor(red:1.00, green:0.55, blue:0.52, alpha:1.0).CGColor
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 1
        self.layer.backgroundColor = UIColor(red:1.00, green:0.55, blue:0.52, alpha:1.0).CGColor
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        

    }
    func addScalingEvents(){
        self.addTarget(self, action: #selector(scaleUp), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(scaleDown), forControlEvents: [.TouchUpInside, .TouchUpOutside])
    }
    func scaleAnimation(xScale: CGFloat, _ yScale: CGFloat){
        self.layer.removeAllAnimations()
        UIView.animateWithDuration(NSTimeInterval(1), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 25.0, options: [], animations: {
            self.transform = CGAffineTransformMakeScale(xScale,yScale)
            
            }, completion: nil)
    }
    
    func scaleDown(){
        scaleAnimation(1, 1)
    }

    func scaleUp(){
        scaleAnimation(1.05, 1.05)
    }
}
