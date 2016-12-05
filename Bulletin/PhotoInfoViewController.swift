//
//  PhotoInfoViewController.swift
//  Bulletin
//
//  Created by Pei Liu on 11/17/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit



class PhotoInfoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var detailsText: UITextView!
    
    let singleton = Singleton.sharedInstance

    @IBOutlet var viewUserButton: UIButton!
    
    @IBOutlet var userImageView: CircleImageView!
    @IBOutlet weak var imageView: UIImageView!
    var photo: ItemPhoto! {
        didSet {
            navigationItem.title = photo.title
            
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    var processingConversation : Bool!
    
    var store: PhotoStore!
    
    func checkMakeConversationComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        guard let resHTTP = response as! NSHTTPURLResponse! else{
            return
        }
        
        guard let jsonData = data else{
            return
        }
        let mainTabController = self.parentViewController!.parentViewController! as! MainTabBarController

        if resHTTP.statusCode == 200 {
            mainTabController.goToMessages()
            conversationButton.setTitle("Conversation started!", forState: .Normal)
            
            let parentVc = self.parentViewController!.parentViewController as! MainTabBarController
            parentVc.refreshConversations()
            
        }else if resHTTP.statusCode == 418{
            conversationButton.setTitle("Started conversation!", forState: .Normal)
            mainTabController.goToMessages()
        }else{
            conversationButton.setTitle("No conversation available!", forState: .Normal)
        }
        processingConversation = false
        
    }
    
    
    @IBAction func conversationTapped(sender: AnyObject) {
        if processingConversation == false {
            conversationButton.setTitle("Starting conversation...", forState: .Normal)
            processingConversation = true
            singleton.API.makeConversation(photo.itemId, completion: checkMakeConversationComplete)
        }
    }
    
    

    @IBOutlet var conversationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        store.fetchImageForPhoto(photo) { (result) -> Void in
            switch result {
            case let .Success(image):
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    self.imageView.image = image
                }
            case let .Failure(e):
                print("Error fetching image: \(e)")
            }
            
        }
        
        let itemPhoto = photo as ItemPhoto
        
        store.fetchUserImageForPhoto(itemPhoto) { (result) -> Void in
            switch result {
            case let .Success(image):
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    self.userImageView.image = image
                }
            case let .Failure(e):
                print("Error fetching image: \(e)")
            }
            
        }
        
        
        titleText.text = photo.title

        detailsText.text = photo.description
       
        let size: CGSize = detailsText.font!.sizeOfString(detailsText.text, constrainedToWidth: Double(self.view.frame.width - 16))
        
        contentViewHeightConstraint.constant = contentViewHeightConstraint.constant + size.height
        print(size.height)
        
        self.view.layoutIfNeeded()
        
        
        viewUserButton.setTitle(itemPhoto.userName, forState: .Normal)
        
        
        processingConversation = false

    }

    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
    }
}
