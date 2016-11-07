//
//  SettingsViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//


import UIKit

class SettingsViewController : UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var firstName: FlatTextField!
    @IBOutlet weak var lastName: FlatTextField!
    @IBOutlet weak var email: FlatTextField!
    @IBOutlet weak var phoneNum: FlatTextField!
    @IBOutlet weak var profilePic: CircleImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.placeholder = "First Name"
        lastName.placeholder = "Last Name"
        email.placeholder = "Jay@sjsu.edu"
        phoneNum.placeholder = "(123) 456 7890"
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SettingsViewController.imageTapped(_:)))
        profilePic.userInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(img: AnyObject) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePic.image = image
        /* Store images in the ImageStore
        imageStore.setImage(image, forKey: item.itemKey)
        imageView.image = image */
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
