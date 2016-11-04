//
//  FlatLabel.swift
//  Bulletin
//
//  Created by Pei Liu on 11/3/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

@IBDesignable class FlatTextField : UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.backgroundColor = Singleton.buttonBgColor
        //self.tintColor = UIColor.whiteColor()
        
        /*
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.borderStyle = UITextBorderStyle.None
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true*/
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, self.frame.height - 2, self.frame.width, 2.0)
        bottomLine.backgroundColor = Singleton.buttonBgColor.CGColor
        self.borderStyle = UITextBorderStyle.None
        self.layer.addSublayer(bottomLine)
    }
}
