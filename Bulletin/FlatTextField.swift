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
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, self.frame.height - 2, self.frame.width, 2.0)
        bottomLine.backgroundColor = Singleton.buttonBgColor.CGColor
        self.borderStyle = UITextBorderStyle.None
        self.layer.addSublayer(bottomLine)
        self.tintColor = Singleton.buttonBgColor
    }
}
