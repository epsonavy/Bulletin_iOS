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
    
    // test only: generate random items
    convenience init(random: Bool = false) {
        if random {
            let adjective = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjective.count))
            let randomAdjective = adjective[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            self.init(name: randomName, price: randomValue)
            
        } else {
            self.init(name: "", price: 0)
        }
    }
}
