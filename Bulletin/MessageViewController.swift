//
//  MessageViewController.swift
//  Bulletin
//
//  Created by Pei Liu on 11/17/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class MessageViewController : UITableViewController {
    let messageStore = Singleton.sharedInstance.messageStore
    let imageStore = Singleton.sharedInstance.imageStore
    
    
    var refreshMessagesControl : UIRefreshControl!
    
    
    let singleton = Singleton.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationController!.navigationBar.tintColor = Singleton.sharedInstance.mainThemeColor
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        refreshMessages()
        
        refreshMessagesControl = UIRefreshControl()
        refreshMessagesControl.addTarget(self, action: #selector(refreshMessages), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshMessagesControl
    }
    
    func checkGetConversationsComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        refreshMessagesControl.endRefreshing()
        guard let resHTTP = response as! NSHTTPURLResponse! else{
            return
        }
        guard let jsonData = data else{
            return
        }
        if resHTTP.statusCode == 200 {
            messageStore.messagesFromData(jsonData)
            self.tableView.reloadData()
        }else if resHTTP.statusCode == 418{
            
        }
        
        
        
        
    }
    
    func refreshMessages(){
        
        singleton.API.getConversations(checkGetConversationsComplete)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMessage" {
            /*
             if let row = tableView.indexPathForSelectedRow?.row{
             let item = itemStore.allItems[row]
             let detailViewController = segue.destinationViewController as! DetailViewController
             detailViewController.item = item
             detailViewController.imageStore = imageStore
             }
            */
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        //cell.updateLabels()
        let item = messageStore.allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.msgDetail.text = item.detail
        cell.timeLabel.text = dateFormatter.stringFromDate(item.dateCreated)
        
        // test only: for random items
        if (item.image != nil) {
            cell.someoneProfile.image = item.image
        }
        
        let key = item.itemKey
        
        if let imageToDisplay = imageStore.imageForKey(key) {
            cell.someoneProfile.image = imageToDisplay
        }
        return cell
    }
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = messageStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                (action) -> Void in
                self.messageStore.removeItem(item)
                self.imageStore.deleteImageForKey(item.itemKey)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic )
            })
            ac.addAction(deleteAction)
            
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }

    
    
    
    
    
}
