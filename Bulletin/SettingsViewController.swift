//
//  SettingsViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//


import UIKit

class SettingsViewController : UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate, ModalPopupDelegate {
    
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet var contentView: UIView!

    @IBOutlet var emailTextField: UIView!
    @IBOutlet var okayButton: UIButton!
    
    @IBOutlet var profileScrollViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var changePasswordTextField: UITextField!
    @IBOutlet var imageView: CircleImageView!
    @IBOutlet var profileScrollView: UIScrollView!
    
    @IBOutlet var okayButtonVerticalConstraint: NSLayoutConstraint!
    
        let imagePicker = UIImagePickerController()
    
    
    var processing : Bool!
    
    let singleton : Singleton = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processing = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShowing), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHiding), name:UIKeyboardWillHideNotification, object: nil)
        
        let tapResignGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignFirstResponders))
        contentView.addGestureRecognizer(tapResignGestureRecognizer)
        
        self.profileScrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        let changePictureTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePicture))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        imageView.userInteractionEnabled = true
        
        imageView.addGestureRecognizer(changePictureTapGesture)
        
    }

    func changePicture(gestureRecognizer: UIGestureRecognizer){
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func resignFirstResponders(){
        changePasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        changeOkayButtonBasedOnResponder()
    }
    
    
    func textFieldDidBeginEditing(textField : UITextField){
        if let seeProcessing = processing{
            if seeProcessing {
                resignFirstResponders()
            }
        }
        
    
        changeOkayButtonBasedOnResponder()
    }
    
    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func modalPopupClosed(sender: ModalPopup) {
        if sender.id == 2{
            self.changePasswordTextField.becomeFirstResponder()
        }else if sender.id == 3 {
            self.confirmPasswordTextField.becomeFirstResponder()
        }
    }
    
    
    func keyboardHiding(notification: NSNotification){
        profileScrollViewVerticalConstraint.constant = okayButton.frame.height
        okayButtonVerticalConstraint.constant =  0
        
        UIView.animateWithDuration(0.75, animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (finished : Bool) -> Void in
                self.profileScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        })
    }
    
    func checkChangePasswordComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if (resCode == 200){
            let modalPopup : ModalPopup = ModalPopup(message: "Password change successful!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with changing your password!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
        }
        processing = false
    }
    
    
    func validatePassword(password: String!) -> Bool{
        
        if password.characters.count < 3 {
            let modalPopup = ModalPopup(message: "Password is too short!", delegate: self)
            modalPopup.id = 2
            modalPopup.show()
            return false
        }
        return true
    }
    
    
    func validateConfirmPassword(confirmPassword: String!) -> Bool{
        if confirmPassword.characters.count < 3 {
            let modalPopup = ModalPopup(message: "Password is too short!", delegate: self)
            modalPopup.id = 3
            modalPopup.show()
            return false
        }
        
        if(self.changePasswordTextField.text != confirmPassword){
            let modalPopup = ModalPopup(message: "Passwords do not match!", delegate: self)
            modalPopup.id = 3
            modalPopup.show()
            return false
        }
        return true
    }
    
    
    
    func tapForward(){
        if changePasswordTextField.isFirstResponder(){
            if validatePassword(self.changePasswordTextField.text){
                confirmPasswordTextField.becomeFirstResponder()
            }else{
                resignFirstResponders()
            }
            
        }else if confirmPasswordTextField.isFirstResponder(){
            if let seeProcessing = processing{
                if seeProcessing == false{
                    if validateConfirmPassword(self.confirmPasswordTextField.text){
                        
                        singleton.API.updatePassword(self.confirmPasswordTextField.text, completion: checkChangePasswordComplete)
                        okayButton.setTitle("Verifying", forState: .Normal)
                        processing = true
                        resignFirstResponders()
                    }else{
                        resignFirstResponders()
                    }

                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        tapForward()
        return true
    }
    
    func checkUpdateComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if (resCode == 200){
            let modalPopup : ModalPopup = ModalPopup(message: "Image upload successful!", delegate: self)
            modalPopup.id = 2
            modalPopup.show()
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with updating your profile!", delegate: self)
            modalPopup.id = 2
            modalPopup.show()
        }
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
                singleton.profilePicture = decodedJson["url"] as! String!
            }
            catch (let e) {
                //Error in parsing
                print(e)
            }
            singleton.API.updateProfilePicture(singleton.profilePicture, completion: checkUpdateComplete)
            
            
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with uploading!", delegate: self)
            modalPopup.id = 2
            modalPopup.show()
            
        }
    }
    
    
    func logout(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("InvalidToken", forKey: "token")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func okayButtonTapped(sender: AnyObject) {
        if changePasswordTextField.isFirstResponder() || confirmPasswordTextField.isFirstResponder(){
            tapForward()
        }else{
            logout()
        }
    }
    func changeOkayButtonBasedOnResponder(){
        if changePasswordTextField.isFirstResponder() {
            okayButton.setTitle("Next", forState: .Normal)
            UIView.animateWithDuration(0.75, animations: {
                self.titleView.alpha = 0.5
            })

        }else if confirmPasswordTextField.isFirstResponder(){
            okayButton.setTitle("Confirm", forState: .Normal)
            UIView.animateWithDuration(0.75, animations: {
                self.titleView.alpha = 0.5
            })
        }else{
            okayButton.setTitle("Logout", forState: .Normal)
            UIView.animateWithDuration(0.75, animations: {
                self.titleView.alpha = 1.0
            })
        }
    }
    
    
    func keyboardShowing(notification: NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        
        changeOkayButtonBasedOnResponder()
        
        profileScrollViewVerticalConstraint.constant = keyboardRect.height - self.tabBarController!.tabBar.frame.height + okayButton.frame.height
        okayButtonVerticalConstraint.constant = keyboardRect.height - self.tabBarController!.tabBar.frame.height
        
        UIView.animateWithDuration(0.75, delay: 0.25, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (finished: Bool) -> Void in
                self.profileScrollView.setContentOffset(CGPoint(x: 0, y: self.contentView.frame.height - self.profileScrollView.frame.height - self.emailTextField.frame.height), animated: true)

        })
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFill
            imageView.image = image
            singleton.API.uploadImage(imageView.image, completion: checkUploadComplete)
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
