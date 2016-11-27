//
//  ItemModel.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/26/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import Foundation

class ItemModel : NSObject{
    var userId: String!
    var title: String!
    var details: String!
    var pictures: [String!]!
    var price: NSNumber!
    var expiration: NSNumber!
    
    
    init(userId: String!, title: String!, details: String!, pictures: [String!], price: NSNumber!, expiration: NSNumber!){
        self.userId = userId
        self.title = title
        self.details = details
        self.pictures = pictures
        self.price = price
        self.expiration = expiration
    }
}
