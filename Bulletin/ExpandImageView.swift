//
//  ExpandImageView.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/18/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ExpandImageView: UIView {
    var images : [UIImage]
    
    var delay : CGFloat!
    
    var imageViewFirst : UIImageView
    var imageViewSecond : UIImageView
    
    var expanding : Bool!
    
    
    func addImage(image: UIImage){
        images.append(image)
    }
    
    var imageCounter : Int!
    
    
    func beginExpanding(){
        expanding = true
        expandFirstImageView()
        UIView.animateWithDuration(NSTimeInterval(delay), animations: {
            self.imageViewFirst.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            }, completion: nil)
    }
    
    func stopExpanding(){
        imageViewFirst.stopAnimating()
        imageViewSecond.stopAnimating()
        expanding = false
    }
    
    
    func prepare(){
        imageViewFirst.image = images[incrementImageCounter()]
    }
    
    
    func expandFirstImageView(){
        if let isExpanding = expanding{
            if isExpanding{
                imageViewSecond.image = images[incrementImageCounter()]
                UIView.animateWithDuration(NSTimeInterval(delay), animations: {
                    self.imageViewFirst.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2)
                    self.imageViewFirst.alpha = 0
                    }, completion: {
                        (finished: Bool) -> Void in
                        self.bringSubviewToFront(self.imageViewSecond)
                        self.imageViewFirst.transform = CGAffineTransformIdentity
                        self.imageViewFirst.alpha = 1
                        self.expandSecondImageView()
                })
                
                UIView.animateWithDuration(NSTimeInterval(delay), animations: {
                    self.imageViewSecond.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                    }, completion: nil)
            }
        }

        
    }
    
    func expandSecondImageView(){
        if let isExpanding = expanding{
            if isExpanding{
                imageViewFirst.image = images[incrementImageCounter()]
                UIView.animateWithDuration(NSTimeInterval(delay), animations: {
                    self.imageViewSecond.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                    self.imageViewSecond.alpha = 0
                    }, completion: {
                        (finished: Bool) -> Void in
                        self.bringSubviewToFront(self.imageViewFirst)
                        self.imageViewSecond.transform = CGAffineTransformIdentity
                        self.imageViewSecond.alpha = 1
                        self.expandFirstImageView()
                        
                })
                UIView.animateWithDuration(NSTimeInterval(delay), animations: {
                    self.imageViewFirst.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                    }, completion: nil)
            }
        }

    }
    
    
    
    
    func incrementImageCounter() -> Int!{
        let retCounter : Int! = imageCounter
        imageCounter = imageCounter + 1
        print(imageCounter)
        print("count \(images.count)")
        if(imageCounter >= images.count) {
           imageCounter = 0
        }
        return retCounter
    }
    
    
    override init(frame: CGRect) {
        images = [UIImage]()
        
        imageViewFirst = UIImageView(frame: frame)
        imageViewSecond = UIImageView(frame: frame)
        
        imageCounter = 0
        
        delay = 5
        
        
        super.init(frame: frame)
        
        
        addSubview(imageViewSecond)
        addSubview(imageViewFirst)
        
    }
    required init?(coder aDecoder: NSCoder) {
        images = [UIImage]()
        
        imageViewFirst = UIImageView(frame: UIScreen().bounds)
        imageViewSecond = UIImageView(frame: UIScreen().bounds)
        
        imageCounter = 0
        
        delay = 5
        
        super.init(coder: aDecoder)
        
        addSubview(imageViewSecond)
        addSubview(imageViewFirst)
        
        

        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
