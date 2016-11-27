//
//  ViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ModalPopupDelegate {
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


        
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true

        
        UIView.setAnimationsEnabled(true)
        
        singleton = Singleton.sharedInstance
        
        passwordViewVerticalConstraint.constant = -passwordView.frame.width
        
        emailViewVerticalConstraint.constant = -emailView.frame.width
        self.view.layoutIfNeeded()
        
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
        self.view.layoutIfNeeded()
        
        
        
    }
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        viewTokenSaved() //this just checks if you already have a token
    }
    
    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func modalPopupClosed(sender: ModalPopup) {
        if sender.id == 1 {
            transitionToRegisterVc()
        }else if sender.id == 4{
            
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
        self.emailViewVerticalConstraint.constant = keyboardRect.height + self.emailPosition
        self.passwordViewVerticalConstraint.constant = keyboardRect.height
        UIView.animateWithDuration(1, animations: {
           self.view.layoutIfNeeded()
        })
        
    }
    
    func keyboardHiding(notification : NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        self.keyboardRect = keyboardRect
        self.emailViewVerticalConstraint.constant =  self.emailPosition
        self.passwordViewVerticalConstraint.constant = 0
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
        })
    }

    
    func showPasswordField(){
        self.passwordTextField.becomeFirstResponder()
        
        self.emailPosition = emailView.frame.height
        self.emailViewVerticalConstraint.constant = self.keyboardRect.height + self.emailPosition
        self.passwordViewVerticalConstraint.constant = self.keyboardRect.height

        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    
    func transitionToRegisterVc(){
        resignFirstResponders()
        singleton.email = self.emailTextField.text
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func promptUserToRegister(){
        let modalPopup : ModalPopup = ModalPopup(message: "Let's get you registered!", delegate: self)
        modalPopup.id = 1
        modalPopup.show()
        resignFirstResponders()
        
    }
    func checkEmailComplete(response: NSURLResponse?, data:NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if(resCode == 418){
            //display popup dialog to ask whether or not user wants to sign up
            
            promptUserToRegister()
        }
        
        if(resCode == 200){
            showPasswordField()
        }
        
        
    }
    
    func validateEmail(email : String!) -> Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let validFormat = emailTest.evaluateWithObject(email)
        if validFormat == false{
            let modalPopup = ModalPopup(message: "Incorrect email address format!", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
            self.emailTextField.resignFirstResponder()
            
            return false
        }
        
        if email.rangeOfString(".edu") == nil {
            let modalPopup = ModalPopup(message: "Please use an .edu email!", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
            self.emailTextField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func promptInvalidAccount(){
        let modalPopup : ModalPopup = ModalPopup(message: "Your account information was not recognized!", delegate: self)
        modalPopup.id = 0
        modalPopup.show()

    }
    
    func showEmailField(){
        self.emailViewVerticalConstraint.constant = 0
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func checkTokenComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        if(resCode == 200){
            transitionToMainTabBar()
        }else{
            showEmailField()
        }
    }
    
    func viewTokenSaved(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey("token"){
            
            //if a token exists
            singleton.API.setToken(token)
            singleton.API.checkToken(token, completion: checkTokenComplete)
            
        }else{
            //no token
            showEmailField()
        }
        
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
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(singleton.API.token, forKey:"token")
            }
            catch (let e) {
                //Error in parsing
                print(e)
            }

            
            transitionToMainTabBar()
            
            
        }
    }
    
    func resignFirstResponders(){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func transitionToMainTabBar(){
        resignFirstResponders()
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.emailTextField.isFirstResponder(){
            //debug purposes..
            if(self.emailTextField.text!.characters.count < 1){
                //display empty field dialog box
                let modalPopup : ModalPopup = ModalPopup(message: "Please enter your campus email address!", delegate: self)
                modalPopup.id = 3
                modalPopup.show()
                resignFirstResponders()
                
            }else{
                if validateEmail(self.emailTextField.text){
                    singleton.API.checkEmailExists(self.emailTextField.text, completion: checkEmailComplete)
                }
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
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        if self.isMovingFromParentViewController(){
            print("mmmm")
            self.expandImageView.prepare()
            self.expandImageView.beginExpanding()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.expandImageView.stopExpanding()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

