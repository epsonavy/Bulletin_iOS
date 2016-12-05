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
        token = "NoToken"
    }
    
    func setToken(token: String!){
        self.token = token
        print ("Token was set to \(token)")
    }
    
    func getToken() -> String!{
        if token == nil{
            return ""
        }
        return token
    }
    
    func getItemsUrl() -> NSURL!{
        return NSURL(string: apiAddress + "/items/all/?token=" + token) as NSURL!
    }
    func getSpecificItem(itemId: String!, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/items/?token=" + getToken() + "&itemId=" + itemId)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    
    func makeConversation(itemId: String, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/conversations/new/?token=" + getToken())
        
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginDetails = ["itemId": itemId]
        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(loginDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    func getConversations(completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/conversations/?token=" + getToken())
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    
    func getUserItems(completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/items/?token=" + getToken())
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    func getSpecificUser(userId: String!, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        
        let url : NSURL! = NSURL(string: apiAddress + "/users/find/?token=" + getToken() + "&userId=" + userId)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    func getUserDetails(completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        
        let url : NSURL! = NSURL(string: apiAddress + "/users/?token=" + getToken())
    
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
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
    
    
    //USE SESSION FOR REGISTRATION
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
    
    func uploadImage(image : UIImage!, completion : (response : NSURLResponse?, data : NSData?, error : NSError?) -> (Void)){
        
        let dataImage : NSData! = UIImageJPEGRepresentation(image, 0.1);
        
        let uploadUrl : NSURL! = NSURL(string: apiAddress + "/upload?token=" + token);
        let request = NSMutableURLRequest(URL: uploadUrl)
        request.HTTPMethod = "POST"
        let boundary = generateBoundaryString()
        let fname = "nothing_important.png"
        let mimetype = "image/png"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body : NSMutableData = NSMutableData()
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(dataImage!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion);
        
    }
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    func updateProfilePicture(imageUrl : String!, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/users/update/")
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginDetails = ["profile_picture": imageUrl, "token" : token]
        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(loginDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
        
        
    }
    
    func sendMessage(conversationId: String, message: String, completion: (response: NSURLResponse?, data:NSData?, error:NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/conversations/messages/?token=" + getToken())
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        var messageDetails = [ "message" : message, "conversationId" : conversationId]
        
        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(messageDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    
    func updatePassword(password : String!, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/users/update/")
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginDetails = ["password": password, "token" : token]
        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(loginDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
        
        
    }
    
    func getAllMessages(conversationId: String, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/conversations/messages/?token=" + getToken() + "&conversationId=" + conversationId + "&from=0")
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    
    
    func createNewItem(title: String, pictureUrl: String, price: NSNumber, description: String, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        
        let url : NSURL! = NSURL(string: apiAddress + "/items/new/?token=" + getToken())
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        var itemDetails : NSDictionary
        if(pictureUrl == "default_item.png"){
            itemDetails = ["title": title, "description" : description, "price" : price]
        }else{
            itemDetails = ["title": title, "description" : description, "pictures": [pictureUrl], "price" : price]
        }

        request.HTTPMethod = "POST"
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(itemDetails, options: .PrettyPrinted)
            request.HTTPBody = jsonData
            print(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }catch{
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion)
    }
    
    
    func checkToken(token: String!, completion: (response: NSURLResponse?, data: NSData?, error: NSError?) -> (Void)){
        let url : NSURL! = NSURL(string: apiAddress + "/auth?token=" + token);
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion);
        
    }

    
}
