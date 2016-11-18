//
//  Singleton.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class Singleton{
    static let sharedInstance = Singleton()
    
    var token : String!
    
    // Main theme color
    let mainThemeColor = UIColor(red:1.00, green:0.55, blue:0.52, alpha:1.0)
    
    // Store item that post by user
    let itemStore = ItemStore()
    let imageStore = ImageStore()
    let messageStore = MessageStore()
    let photoStore = PhotoStore()
    
}
