//
//  CircleImage.swift
//  Bulletin
//
//  Created by Pei Liu on 11/3/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

@IBDesignable class CircleImageView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = Singleton.sharedInstance.secondaryColor.CGColor
    }
}
