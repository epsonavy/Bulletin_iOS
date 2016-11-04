//
//  GrayBar.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class GrayBarView : UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context!, 0, 0)
        CGContextAddLineToPoint(context!, 0, rect.height)
        CGContextAddLineToPoint(context!, rect.width, rect.height)
        CGContextAddLineToPoint(context!, rect.width, 0)
        CGContextAddLineToPoint(context!, 0, 0)
        CGContextSetFillColorWithColor(context!, UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1.0).CGColor)
        CGContextFillPath(context!)
        
        let borderHeight: CGFloat? =  1.5
        CGContextMoveToPoint(context!, 0, rect.height - borderHeight!)
        CGContextAddLineToPoint(context!, rect.width, rect.height - borderHeight!)
        CGContextAddLineToPoint(context!, rect.width, rect.height)
        CGContextAddLineToPoint(context!, 0, rect.height)
        CGContextAddLineToPoint(context!, 0, rect.height - borderHeight!)
        CGContextSetFillColorWithColor(context!, UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.0).CGColor)
        CGContextFillPath(context!)
    }
}
