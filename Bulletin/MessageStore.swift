//
//  MessageStore.swift
//  Bulletin
//
//  Created by Pei Liu on 11/16/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class MessageStore {
    var allItems = [Message]()
    
    //test only
    init() {
        

        /*
        for _ in 0..<3 {
            createItem()
        }
        */
    }
    
    func messagesFromData(data: NSData){
        allItems.removeAll()
        var decodedJson : AnyObject
        do {
            decodedJson = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            
            let conversations = decodedJson as! NSArray
            for var conversation in conversations{
                
                let conversationDetails = conversation as! NSDictionary
                let userStartId = conversationDetails["userStart"] as! String
                let userWithId = conversationDetails["userWith"] as! String
                
                var name: String
                
                var userImage: String
                
                if(userStartId == Singleton.sharedInstance.userId){
                    //take with
                    name = conversationDetails["userWithName"] as! String
                    userImage = conversationDetails["userWithProfilePicture"] as! String
                    
                }else{
                    name = conversationDetails["userStartName"] as! String
                    userImage = conversationDetails["userStartProfilePicture"] as! String
                    //take start
                }
                
                
                let lastMessage = conversationDetails["lastMessage"] as! String
                let lastTimestamp = conversationDetails["lastTimestamp"] as! NSNumber
                
                let conversationId = conversationDetails["_id"] as! String
                
                let itemId = conversationDetails["itemId"] as! String
       

                
                allItems.append(Message(name: name, detail: lastMessage, url: userImage, itemKey: itemId, conversationId: conversationId, dateCreated: lastTimestamp))
            
                
                
            }
        }catch(let e){
            print(e)
        }

        
    }
    /*
    func createItem() -> Message {

        let newItem = Message(random: true)
        
        allItems.append(newItem)
        
        return newItem
 
    }

 
    func addEmptyItem() -> Message {

        let newItem = Message(random: false)
        
        allItems.append(newItem)
        
        return newItem

    }
     func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
     if fromIndex == toIndex {
     return
     }
     
     let moveItem = allItems[fromIndex]
     allItems.removeAtIndex(fromIndex)
     allItems.insert(moveItem, atIndex: toIndex)
     }
     */
    func removeItem(item: Message) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    

 
}
