//
//  ItemImageView.swift
//  Bulletin
//
//  Created by Pei Liu on 11/5/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

@IBDesignable class ItemImageView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width / 6
        self.clipsToBounds = true
        self.layer.borderWidth = 4
        self.layer.borderColor = Singleton.sharedInstance.mainThemeColor.CGColor
    }
}
