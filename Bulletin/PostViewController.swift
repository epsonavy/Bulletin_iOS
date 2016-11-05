//
//  PostViewController.swift
//  Bulletin
//
//  Created by Pei Liu on 11/04/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit
class PostViewController : UITableViewController {
    //var itemStore: ItemStore!
    let itemStore = Singleton.sharedInstance.itemStore
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationController!.navigationBar.tintColor = Singleton.sharedInstance.mainThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.rowHeight = 200
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 65
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row{
                let item = itemStore.allItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
                //detailViewController.imageStore = imageStore
            }
        }
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem =  itemStore.createItem()
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        cell.updateLabels()
        let item = itemStore.allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.valueLabel.text = "$\(item.price)"
        
        return cell
    }
    
    /* We don't need to move item
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    } 
    */
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            self.itemStore.removeItem(item)
            //self.imageStore.deleteImageForKey(item.itemKey)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic )
        }
    }
}
