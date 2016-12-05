//
//  MessageEntity.swift
//  Bulletin
//
//  Created by Kevin Trinh on 12/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import Foundation
class MessageEntity : NSObject{
    
    var name: String
    var timestamp: NSDate
    var message: String
    var messageIndex: Int
    
    init(name: String, timestamp: NSNumber, message: String, messageIndex: Int){
        
        self.name = name
        self.timestamp = NSDate(timeIntervalSince1970: timestamp.doubleValue)
        self.message = message
        self.messageIndex = messageIndex
        
        super.init()
    }
}
