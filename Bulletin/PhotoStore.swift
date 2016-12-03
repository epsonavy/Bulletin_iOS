//
//  PhotoStore.swift
//  Bulletin
//
//  Created by Pei Liu on 11/17/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError: ErrorType {
    case ImageCreationError
}

class PhotoStore {
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
            }
            completion(result)
        }
        task.resume()
    }
    
    func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult {
        guard let
            imageData = data,
            image = UIImage(data: imageData)
            else {
                return .Failure(PhotoError.ImageCreationError)
        }
        return .Success(image)
    }
    
    func processRecentPhotosRequest(data data: NSData?, error: NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return FlickrAPI.photoFromJSONData(jsonData)
    }
    
    
    func processItemsJSONData(data: NSData!) -> PhotosResult{
        
        var decodedJson : AnyObject
        do {
            decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            let items = decodedJson as! NSArray
            
            var photos = [Photo]()
            
            for var item in items{
                
                let itemDescription = item as! NSDictionary
                let title = itemDescription["title"] as! String
                let itemId = itemDescription["_id"] as! String
                let userId = itemDescription["userId"] as! String
                let description = itemDescription["description"] as! String
                let price = itemDescription["price"] as! NSNumber
                let expiration = itemDescription["expiration"] as! NSNumber
                let pictures = itemDescription["pictures"] as! NSArray
                let picture : NSURL! = NSURL(string: pictures[0] as! String)
                
                photos.append(ItemPhoto(title: title, photoID: itemId, remoteURL: picture, dateTaken: NSDate(), itemId: itemId, userId: userId, description: description, price: price, expiration: expiration))
                
            }
            return .Success(photos)
        }
        catch (let e) {
            
            return .Failure(e)
        }


    }
    
    func processItemsRequest(data data: NSData?, response: NSURLResponse?, error: NSError?) -> PhotosResult{
        guard let responseHttp = response as! NSHTTPURLResponse? else {
            return .Failure(error!)
        }
        
        guard let jsonData = data else {
            return .Failure(error!)
        }
        print(responseHttp.statusCode)
        if responseHttp.statusCode == 200 {
            return self.processItemsJSONData(jsonData)
            
        }
        return .Failure(FlickrError.InvalidJSONData)
    }
    
    
    func getItems(completion completion: (PhotosResult) -> Void) {
        
        let url = Singleton.sharedInstance.API.getItemsUrl()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processItemsRequest(data: data, response: response, error: error)
            completion(result)
            
        }
        task.resume()
    }
}
