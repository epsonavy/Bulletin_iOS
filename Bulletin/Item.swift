//
//  Item.swift
//  Bulletin
//
//  Created by Pei Liu on 11/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String
    var price: Int
    let dateCreated: NSDate
    
    init(name: String, price: Int) {
        self.name = name
        self.price = price
        self.dateCreated = NSDate()
        
        super.init()
    }
}
