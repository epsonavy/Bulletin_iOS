//
//  ActivityViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ActivityViewController : UITableViewController{
    @IBOutlet var itemsCountLabel: UILabel!
    
    let refreshItemsControl : UIRefreshControl = UIRefreshControl()
    
    let singleton = Singleton.sharedInstance
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        refreshItems()
        refreshItemsControl.addTarget(self, action: #selector(refreshItems), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshItemsControl
        
        self.tableView.separatorStyle = .None
       
        
    }
    
    func checkUserItemsComplete(response: NSURLResponse?, data: NSData?, error:NSError?){
        let resHTTP = response as! NSHTTPURLResponse
        let resCode = resHTTP.statusCode
        
        if(resCode == 200){
            var decodedJson : AnyObject
            do{
                decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let itemsArray : NSArray = decodedJson as! NSArray
                
                 singleton.items.removeAll()
                for var item in itemsArray{
                    let itemDictionary = item as! NSDictionary
                    
                    let itemModel = ItemModel(userId: itemDictionary["userId"] as! String!, title: itemDictionary["title"] as! String!, details: itemDictionary["description"] as! String!, pictures: [String!](), price: itemDictionary["price"] as! NSNumber!, expiration: itemDictionary["expiration"] as! NSNumber!)
                    
                    let pictureArray = itemDictionary["pictures"] as! NSArray!
                    for var picture in pictureArray{
                        itemModel.pictures.append(picture as! String)
                    }
                    
                    singleton.items.append(itemModel)
                    
                }
            
                
                print(itemsArray.count)
                if(itemsArray.count == 1){
                    itemsCountLabel.text = "\(itemsArray.count) item"
                }else{
                    itemsCountLabel.text = "\(itemsArray.count) items"
                }
                
                tableView.reloadData()

                //This should update the settings page properly
                
            }catch(let e){
                print(e)
            }
            
        }else if (resCode == 418){
            itemsCountLabel.text = "No items."
        }
        
        refreshItemsControl.endRefreshing()

    }
    
    func refreshItems(){
        singleton.API.getUserItems(checkUserItemsComplete)
    }
    
    override func didReceiveMemoryWarning() {
        
    super.didReceiveMemoryWarning()
    }
}
