//
//  BulletinAPI.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/18/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class BulletinAPI{
    var apiAddress : String!
    
    var token : String!
    
    
    init(_ address: String!){
        apiAddress = address
        //retrieve token from preferences OR make it empty..
        token = ""
    }
    
    func setToken(token: String!){
        self.token = token
        print ("Token was set to \(token)")
    }
    
    func getToken() -> String!{
        return token
    }
    
    
    func checkEmailExists(email: String!, completion : (response : NSURLResponse?, data : NSData?, error : NSError?) -> (Void)){
        //  /register/check
        
        let url : NSURL! = NSURL(string: apiAddress + "/register/check/email/?email=" + email);
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion);
    }
    
    func checkDisplayNameExists(displayName: String!, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/register/check/name/?display_name=" + displayName)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
        
    }
    
    func login(email: String!, password: String!, completion : (response : NSURLResponse?, data : NSData?, error : NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/auth/")
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginDetails = ["email": email, "password" : password]
        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(loginDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
        
    }
    
    
    func register(email: String!, displayName: String!, password: String!, completion : (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        
        let url : NSURL! = NSURL(string: apiAddress + "/register/")
        
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginDetails = ["email": email, "password" : password, "display_name" : displayName]
        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(loginDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
        
        
    }
    
    //USE SESSION FOR REGISTRATION
    
}
