//
//  ItemPhoto.swift
//  Bulletin
//
//  Created by Kevin Trinh on 12/2/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ItemPhoto : Photo{
    let price: NSNumber
    let description: String
    let expiration: NSNumber
    let userId: String
    let itemId: String
    var userImage : UIImage?
    let userName: String
    
    let userProfilePictureUrl: String
    
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate, itemId: String, userId: String, description: String, price: NSNumber, expiration: NSNumber, userName: String, userProfilePictureUrl: String) {
        self.userName = userName
        self.userProfilePictureUrl = userProfilePictureUrl
        self.itemId = itemId
        self.userId = userId
        self.expiration = expiration
        self.description = description
        self.price = price
        
        super.init(title: title, photoID: photoID, remoteURL: remoteURL, dateTaken: dateTaken)
        print(self.userId)
        print(Singleton.sharedInstance.userId)
        
    }
}
