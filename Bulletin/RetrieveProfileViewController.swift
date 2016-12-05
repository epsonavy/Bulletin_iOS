//
//  RetrieveProfileViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 12/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class RetrieveProfileViewController: UIViewController {
    
    let singleton = Singleton.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        getProfileDetails()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func checkUserProfileComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        guard let resHTTP = response as! NSHTTPURLResponse! else{
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
            return
        }
        let resCode = resHTTP.statusCode
        
        if(resCode == 200){
            var decodedJson : AnyObject
            do{
                decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                singleton.email = decodedJson["email"] as! String!
                singleton.displayName = decodedJson["display_name"] as! String!
                singleton.userId = decodedJson["_id"] as! String!
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
                self.presentViewController(vc, animated: true, completion: nil)
                
                //This should update the settings page properly
                
            }catch(let e){
                print(e)
            }
            
        }else{
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func getProfileDetails(){
        singleton.API.getUserDetails(checkUserProfileComplete)
    }
    
    
}
