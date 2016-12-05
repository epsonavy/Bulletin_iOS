//
//  Message.swift
//  Bulletin
//
//  Created by Pei Liu on 11/8/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class Message: NSObject {
    var name: String
    var detail: String
    let dateCreated: NSDate
    let itemKey: String
    var image: UIImage?
    var conversationId: String
    
    init(name: String, detail: String, url: String, itemKey: String, conversationId: String, dateCreated: NSNumber) {
        self.name = name
        self.detail = detail
        self.dateCreated = NSDate(timeIntervalSince1970: dateCreated.doubleValue)
        self.conversationId = conversationId
        self.itemKey = itemKey

        super.init()
        if (url.characters.count > 4) {
            load_image(url)
        } else {
            self.image = nil
        }
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
    /*
    convenience init(random: Bool = false) {
        /*
        if random {
            let adjective = ["Hello", "Still available?", "Hi, I am ..."]
            let nouns = ["Kevin", "Peter", "Jeff"]
            let urls = ["http://45.62.255.194/sample1.jpg",
                        "http://45.62.255.194/sample2.jpg",
                        "http://45.62.255.194/sample3.jpg"]
            
            var idx = arc4random_uniform(UInt32(adjective.count))
            let randomAdjective = adjective[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomNoun)"
            let randomDetail = "\(randomAdjective)"
            
            idx = arc4random_uniform(UInt32(urls.count))
            let randomUrl = urls[Int(idx)]
            
            self.init(name: randomName, detail: randomDetail, url: randomUrl)
            
        } else {
            self.init(name: "No Name", detail:"No Detail", url: "")
        }
 */
    }
 */
}
