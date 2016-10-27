//
//  OrangeBarView.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class OrangeBarView : UIView{
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect){
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, 0,0)
        CGContextAddLineToPoint(context, rect.width, 0)
        CGContextAddLineToPoint(context, rect.width, rect.height)
        CGContextAddLineToPoint(context, 0, rect.height)
        CGContextAddLineToPoint(context, 0, 0)
        CGContextSetFillColorWithColor(context, UIColor(red:1.00, green:0.55, blue:0.47, alpha:1.0).CGColor)
        CGContextFillPath(context)
    }
}