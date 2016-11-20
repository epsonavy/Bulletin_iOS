//
//  ViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, ModalPopupDelegate {
    @IBOutlet var titleView: UIView!

    @IBOutlet var emailView: UIView!
    
    @IBOutlet var passwordViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var emailViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var passwordView: UIView!
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    
    var expandImageView : ExpandImageView!
    
    var singleton : Singleton!
    
    
    var keyboardRect : CGRect!
    var emailPosition : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        singleton = Singleton.sharedInstance
        
        passwordViewVerticalConstraint.constant = -passwordView.frame.width
        
        emailViewVerticalConstraint.constant = 0
        
        expandImageView = ExpandImageView(frame: self.view.frame)
        expandImageView.addImage(UIImage(named: "background.jpg")!)
        expandImageView.addImage(UIImage(named: "background_second.jpg")!)
        expandImageView.addImage(UIImage(named: "asian_ghetto_men.png")!)
        
        emailPosition = 0
        
        
        expandImageView.prepare()
        
        expandImageView.beginExpanding()
        
        self.view.addSubview(expandImageView)
        self.view.bringSubviewToFront(passwordView)
        self.view.bringSubviewToFront(emailView)
        self.view.bringSubviewToFront(titleView)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShowing), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHiding), name:UIKeyboardWillHideNotification, object: nil)
        
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        
        emailTextField.returnKeyType = .Next
        
        passwordTextField.returnKeyType = .Go
        
        
        let hideKeyboardRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        expandImageView.addGestureRecognizer(hideKeyboardRecognizer)
        
        
        
    }
    
    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func modalPopupClosed(sender: ModalPopup) {
        if sender.id == 1 {
            transitionToRegisterVc()
        }else if sender.id == 3{
            transitionToRegisterVc()
        }
    }
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    
    
    func keyboardShowing(notification: NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        self.keyboardRect = keyboardRect
        UIView.animateWithDuration(1, animations: {
            self.emailViewVerticalConstraint.constant = keyboardRect.height + self.emailPosition
        })
        UIView.animateWithDuration(1, animations: {
            self.passwordViewVerticalConstraint.constant = keyboardRect.height
        })
        
    }
    
    func keyboardHiding(notification : NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        self.keyboardRect = keyboardRect
        UIView.animateWithDuration(1, animations: {
            self.emailViewVerticalConstraint.constant =  self.emailPosition
        })
        UIView.animateWithDuration(1, animations: {
            self.passwordViewVerticalConstraint.constant = 0
        })
    }

    
    
    func showPasswordField(){
        self.passwordTextField.becomeFirstResponder()
        
        self.emailPosition = emailView.frame.height
        
        UIView.animateWithDuration(1, animations: {
            self.emailViewVerticalConstraint.constant = self.keyboardRect.height + self.emailPosition
        })
        
        UIView.animateWithDuration(1, animations: {
            self.passwordViewVerticalConstraint.constant = self.keyboardRect.height
        })
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex == 1){
            transitionToRegisterVc()
        }
    }
    
    
    func transitionToRegisterVc(){
        singleton.email = self.emailTextField.text
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func promptUserToRegister(){
        let modalPopup : ModalPopup = ModalPopup(message: "Let's get you registered!", delegate: self)
        modalPopup.id = 1
        modalPopup.show()
        
    }
    func checkEmailComplete(response: NSURLResponse?, data:NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if(resCode == 418){
            //display popup dialog to ask whether or not user wants to sign up
            
            
            promptUserToRegister()
        }
        
        
        
        
        //if successful..
        if(resCode == 200){
            showPasswordField()
        }
        
        
    }
    
    func promptInvalidAccount(){
        let modalPopup : ModalPopup = ModalPopup(message: "Your account information was not recognized!", delegate: self)
        modalPopup.id = 0
        modalPopup.show()
    }
    
    func checkLoginComplete(response: NSURLResponse?, data:NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if(resCode == 418){
            promptUserToRegister()
        }else if (resCode == 400){
            promptInvalidAccount()
        }else if (resCode == 200){
            //get the token and store it
            
            var decodedJson : AnyObject
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                singleton.API.setToken(decodedJson["token"] as! String!)
            }
            catch (let e) {
                //Error in parsing
                print(e)
            }

            
            transitionToMainTabBar()
            
            
        }
    }
    
    func transitionToMainTabBar(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.emailTextField.isFirstResponder(){
            self.emailTextField.resignFirstResponder()
            
            //debug purposes..
            if(self.emailTextField.text!.characters.count < 1){
                //display empty field dialog box
                let modalPopup : ModalPopup = ModalPopup(message: "Please enter your campus email address! (Debug mode)", delegate: self)
                modalPopup.id = 3
                modalPopup.show()
                
            }else{
                singleton.API.checkAccountExists(self.emailTextField.text, completion: checkEmailComplete)
            }
            
            return true
        }
        if self.passwordTextField.isFirstResponder(){
            self.passwordTextField.resignFirstResponder()
            
            singleton.API.login(self.emailTextField.text, password: self.passwordTextField.text, completion: checkLoginComplete)
            
            return true
        }
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.expandImageView.stopExpanding()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

