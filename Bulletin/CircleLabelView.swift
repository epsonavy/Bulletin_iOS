//
//  CircleLabelView.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class CircleLabelView : UILabel{
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.textColor = UIColor(red:1.00, green:0.55, blue:0.47, alpha:1.0)
        self.backgroundColor = UIColor.clearColor()
    }
    override func drawTextInRect(rect: CGRect) {
        let innerRadius : CGFloat = 2
        let circle = UIBezierPath(ovalInRect: CGRect(x: rect.origin.x + innerRadius / 2, y: rect.origin.y + innerRadius / 2, width: rect.width - innerRadius, height: rect.height - innerRadius))
        circle.lineWidth = 2
        UIColor(red:1.00, green:0.55, blue:0.47, alpha:1.0).setStroke()
        circle.stroke()
        super.drawTextInRect(rect)
    }

}