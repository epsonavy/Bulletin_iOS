//
//  ViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 10/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleView: UIView!

    @IBOutlet var emailView: UIView!
    
    @IBOutlet var passwordViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var emailViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var passwordView: UIView!
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    
    var expandImageView : ExpandImageView!
    
    
    var keyboardRect : CGRect!
    var emailPosition : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    func transitionToRegisterVc(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.emailTextField.isFirstResponder(){
            self.emailTextField.resignFirstResponder()
            
            //debug purposes..
            if(self.emailTextField.text!.characters.count < 1){
                transitionToRegisterVc()
            }
            
            showPasswordField()
            return true
        }
        if self.passwordTextField.isFirstResponder(){
            self.passwordTextField.resignFirstResponder()
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

