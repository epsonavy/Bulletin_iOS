//
//  FlickrAPI.swift
//  Bulletin
//
//  Created by Pei Liu on 11/17/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//


import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case Success([Photo])
    case Failure(ErrorType)
}

enum FlickrError: ErrorType {
    case InvalidJSONData
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIkey = "b6c1e22b19b0e640ee3acde67c9368ff"
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func photoFromJSONData(data: NSData) -> PhotosResult {
        do {
            let jsonObject: AnyObject
                =  try NSJSONSerialization.JSONObjectWithData(data, options: [])
            guard let
                jsonDictionary = jsonObject as? [NSObject: AnyObject],
                photos = jsonDictionary["photos"] as? [String: AnyObject],
                photosArray = photos["photo"] as? [[String: AnyObject]] else {
                    return .Failure(FlickrError.InvalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                return .Failure(FlickrError.InvalidJSONData)
            }
            
            return .Success(finalPhotos)
        } catch let e {
            return .Failure(e)
        }
    }
    
    private static func photoFromJSONObject(json: [String: AnyObject]) -> Photo? {
        guard let
            photoID = json["id"] as? String,
            title = json["title"] as? String,
            dateString = json["datetaken"] as? String,
            photoURLString = json["url_h"] as? String,
            url = NSURL(string: photoURLString),
            dateTaken = dateFormatter.dateFromString(dateString) else {
                return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
    private static func flickrURL(method method: Method, parameters: [String:String]?) -> NSURL {
        let components = NSURLComponents(string: baseURLString)!
        
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIkey
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let addtionalParams = parameters {
            for (key, value) in addtionalParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.URL!
    }
    
    static func recentPhotoURL() -> NSURL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
}
