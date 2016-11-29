//
//  ItemStore.swift
//  Bulletin
//
//  Created by Pei Liu on 11/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()

    let itemArchiveURL: NSURL = {
        let documentsDirectories =
            NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")!
    }()
    
    /* test random 3 items only
    init() {
        for _ in 0..<3 {
            createItem()
        }
    }*/
    
    init() {
        if let archivedItems =
            NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
    }
    
    func saveChanges()->Bool {
        print("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func addEmptyItem() -> Item {
        let newItem = Item(random: false)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(item: Item) {
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
