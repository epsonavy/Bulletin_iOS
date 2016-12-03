//
//  ActivityViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ActivityViewController : UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate , UITextFieldDelegate, ModalPopupDelegate{
    
    let singleton = Singleton.sharedInstance
    
    
    @IBOutlet var titleView: UIView!
    
    
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var priceTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var selectedImageUrl : String = ""
    
    
    @IBOutlet var descriptionTextView: UITextView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        selectedImageUrl = "default_item.png"
        
        let changePictureTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePicture))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        itemImageView.userInteractionEnabled = true
        
        itemImageView.addGestureRecognizer(changePictureTapGesture)

       
        
    }

    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func modalPopupClosed(sender: ModalPopup) {
    }
    
    func changePicture(gestureRecognizer: UIGestureRecognizer){
        self.presentViewController(imagePicker, animated: true, completion: nil)
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func checkUploadComplete(response: NSURLResponse?, data:NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        print(resCode)
        
        if (resCode == 200){
            //get the token and store it
            
            var decodedJson : AnyObject
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                self.selectedImageUrl = decodedJson["url"] as! String!
                let modalPopup : ModalPopup = ModalPopup(message: "Image upload successful!", delegate: self)
                modalPopup.id = 4
                modalPopup.show()
                
            }
            catch (let e) {
                //Error in parsing
                print(e)
            }
            
            
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with uploading!", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
            itemImageView.image = UIImage(named: "default_item.png")
            
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            itemImageView.contentMode = .ScaleAspectFill
            itemImageView.image = image
            singleton.API.uploadImage(itemImageView.image, completion: checkUploadComplete)
        }else{
            itemImageView.image = UIImage(named:"default_item.png")
            selectedImageUrl = "default_item.png"
        }
        /* Store images in the ImageStore
         imageStore.setImage(image, forKey: item.itemKey)
         imageView.image = image */
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        
    super.didReceiveMemoryWarning()
    }
}
