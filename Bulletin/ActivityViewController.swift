//
//  ActivityViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ActivityViewController : UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate , UITextFieldDelegate, UITextViewDelegate, ModalPopupDelegate {
    
    let singleton = Singleton.sharedInstance
    
    @IBOutlet var titleView: UIView!
    
    @IBOutlet var postButton: UIButton!

    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var descriptionTextView: UITextView!
    
    let imagePicker = UIImagePickerController()
    
    var selectedImageUrl : String = ""
    
    var processingPost : Bool!
    
    @IBAction func descriptionTextTapped(sender: UITapGestureRecognizer) {
        
        // future improvement
    }
    
    // Tap to deactivate the keyboard show up
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Dismissing the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.scrollView.contentOffset = CGPointMake(0, self.descriptionTextView.contentSize.height * 2);
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        self.scrollView.contentOffset = CGPointMake(0, self.descriptionTextView.contentSize.height * 2);
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        processingPost = false
        
        selectedImageUrl = "default_item.png"
        
        let changePictureTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePicture))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        itemImageView.userInteractionEnabled = true
        
        itemImageView.addGestureRecognizer(changePictureTapGesture)
 
    }
    
    func checkPostComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        guard let resHTTP = response as! NSHTTPURLResponse! else{
            return
        }
        
        guard let jsonData = data else {
            return
        }
        
        if resHTTP.statusCode == 200 {
            setToDefaults()
            let modalPopup : ModalPopup = ModalPopup(message: "Posted successfully!", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
            
            let parentVc = self.parentViewController!.parentViewController as! MainTabBarController
            parentVc.refreshItems()
            
            

        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with posting", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
        }
        processingPost = false
        
    }
    
    func setToDefaults(){
        self.priceTextField.text = ""
        self.titleTextField.text = ""
        self.descriptionTextView.text = ""
        self.selectedImageUrl = "default_item.png"
        self.itemImageView.image = UIImage(named: "default_item.png")
    }
    
    
    @IBAction func postTapped(sender: AnyObject) {
        if processingPost == false{
            processingPost = true
            singleton.API.createNewItem(self.titleTextField.text!, pictureUrl: self.selectedImageUrl, price: NSNumberFormatter().numberFromString(self.priceTextField.text!)!, description: self.descriptionTextView.text, completion: checkPostComplete)
        }
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
        view.endEditing(true)
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
