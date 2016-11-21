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
    

    
}
