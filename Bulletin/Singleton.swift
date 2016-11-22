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
    
    //replace with aws address later
    //REMOVE THE last /
    let API : BulletinAPI = BulletinAPI("http://localhost:8080/api")
    
    
    //pretty vital. you need this or nothing will work.
    var token : String!
    
    // Main theme color
    let mainThemeColor = UIColor(red:1.00, green:0.54, blue:0.48, alpha:1.0)
    let secondaryColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    
    // Store item that post by user
    let itemStore = ItemStore()
    let imageStore = ImageStore()
    let messageStore = MessageStore()
    let photoStore = PhotoStore()
    
    //user information for registering process
    //these should already be validated by Register View Controller
    var email : String!
    var password: String!
    var displayName : String!
    var profilePicture: String!
    
    
    
}
