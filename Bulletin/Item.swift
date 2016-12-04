//
//  Item.swift
//  Bulletin
//
//  Created by Pei Liu on 11/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var price: NSNumber
    let dateCreated: NSDate
    let itemKey: String
    var image: UIImage?
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        price = aDecoder.decodeIntegerForKey("price") as NSNumber
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
        itemKey = aDecoder.decodeObjectForKey("itemKey") as! String
        image = aDecoder.decodeObjectForKey("image") as! UIImage?
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(price, forKey: "price")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeObject(itemKey, forKey: "itemKey")
        aCoder.encodeObject(image, forKey: "image")
        print("hello")
    }
    
    init(name: String, price: NSNumber, url: String) {
        self.name = name
        self.price = price
        self.dateCreated = NSDate()
        self.itemKey = NSUUID().UUIDString
        super.init()
        /*
        if (url.characters.count > 4) {
            load_image(url)
        } else {
            self.image = nil
        }*/
    }
    
    // test only: load image from url
    func load_image(urlString:String) {
        
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.image = UIImage(data: data!)
                }
        })
    }
    
    // test only: generate random items
    convenience init(random: Bool = false) {
        if random {
            let adjective = ["Macbook Air", "Macbook Pro", "Surface Pro"]
            let nouns = ["2014", "2015", "2016"]
            let urls = ["http://45.62.255.194/sample1.jpg",
                       "http://45.62.255.194/sample2.jpg",
                       "http://45.62.255.194/sample3.jpg"]
            
            var idx = arc4random_uniform(UInt32(adjective.count))
            let randomAdjective = adjective[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(2000))
            
            idx = arc4random_uniform(UInt32(urls.count))
            let randomUrl = urls[Int(idx)]
            
            self.init(name: randomName, price: randomValue, url: randomUrl)
            
        } else {
            self.init(name: "Please edit this item", price: 0, url: "")
        }
    }
}
