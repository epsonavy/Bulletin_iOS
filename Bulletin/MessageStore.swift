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
        for _ in 0..<3 {
            createItem()
        }
    }
    
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
    
    func removeItem(item: Message) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let moveItem = allItems[fromIndex]
        allItems.removeAtIndex(fromIndex)
        allItems.insert(moveItem, atIndex: toIndex)
    }
}
