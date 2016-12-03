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


    @IBOutlet var viewUserButton: UIButton!
    
    @IBOutlet var userImageView: CircleImageView!
    @IBOutlet weak var imageView: UIImageView!
    var photo: ItemPhoto! {
        didSet {
            navigationItem.title = photo.title
            
        }
    }
    var store: PhotoStore!
    

    
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
        titleText.text = photo.title


        detailsText.text = photo.description
       
        let size: CGSize = detailsText.font!.sizeOfString(detailsText.text, constrainedToWidth: Double(self.view.frame.width - 16))
        
        contentViewHeightConstraint.constant = contentViewHeightConstraint.constant + size.height
        print(size.height)
        
        self.view.layoutIfNeeded()
        
        viewUserButton.setTitle("User", forState: .Normal)

    }

    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
    }
}
