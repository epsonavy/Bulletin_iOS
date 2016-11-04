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
        self.layer.cornerRadius = 0
        self.backgroundColor = Singleton.buttonBgColor
        self.tintColor = UIColor.whiteColor()
    }
}
