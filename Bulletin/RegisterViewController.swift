//
//  RegisterViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/20/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController, UIGestureRecognizerDelegate, ModalPopupDelegate{
    @IBOutlet var titleView: UIView!

    @IBOutlet var emailView: UIView!
    @IBOutlet var displayNameView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmPasswordView: UIView!
    
    
    //i will make this a control later.
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var emailVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var displayNameVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var passwordVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var confirmPasswordVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet var okayButton: UIButton!
    
    @IBOutlet var okayButtonVerticalConstraint: NSLayoutConstraint!
    
    var position : Int!
    
    var firstKeyboard : Bool!
    
    var keyboardRect : CGRect!
    
    let fieldViewHeight : CGFloat = 50.0
    
    var backTapView : UIView!
    
    var processing : Bool!
    
    
    let singleton : Singleton! = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        position = 0
        firstKeyboard = true
        processing = false
        //shouldve made it a fucking scrollview
    
        
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        self.view.bringSubviewToFront(titleView) //this guy has to appear first..
        self.view.bringSubviewToFront(okayButton)
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        displayNameTextField.autocorrectionType = UITextAutocorrectionType.No
        
        emailTextField.returnKeyType = UIReturnKeyType.Continue
        displayNameTextField.returnKeyType = UIReturnKeyType.Continue
        passwordTextField.returnKeyType = UIReturnKeyType.Continue
        confirmPasswordTextField.returnKeyType = UIReturnKeyType.Go
        
        emailTextField.text = singleton.email
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShowing), name: UIKeyboardWillShowNotification, object: nil)
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHiding), name: UIKeyboardWillHideNotification, object: nil)
        
        
        emailVerticalConstraint.constant = 0
        displayNameVerticalConstraint.constant = 0
        passwordVerticalConstraint.constant = 0
        confirmPasswordVerticalConstraint.constant = 0
        
        
        okayButton.addTarget(self, action: #selector(tapForward), forControlEvents: .TouchUpInside)
        

    }
    
    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func modalPopupClosed(sender: ModalPopup) {
        if sender.id == 0{
            emailTextField.becomeFirstResponder()
        }else if sender.id == 1{
            displayNameTextField.becomeFirstResponder()
        }else if sender.id == 2{
            passwordTextField.becomeFirstResponder()
        }else if sender.id == 3{
            confirmPasswordTextField.becomeFirstResponder()
        }else if sender.id == 4 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
     
    }
    
    //use some regular exppressions here..
    
    func validateEmail(email : String!) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let validFormat = emailTest.evaluateWithObject(email)
        if validFormat == false{
            let modalPopup = ModalPopup(message: "Incorrect email address format!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
            
            return false
        }
        
        if email.rangeOfString(".edu") == nil {
            let modalPopup = ModalPopup(message: "Please use an .edu email!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
            return false
        }
        
        
        
        return true
    }
    
    func keyboardHiding(notification: NSNotification){
        okayButtonVerticalConstraint.constant = 0
        UIView.animateWithDuration(2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func validateDisplayName(displayName : String!) -> Bool{
        let RegEx = "\\A\\w{3,22}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let validFormat = Test.evaluateWithObject(displayName)
        
        if displayName.characters.count < 3 {
            let modalPopup = ModalPopup(message: "Display name is too short!", delegate: self)
            modalPopup.id = 1
            modalPopup.show()
            return false
        }
        if displayName.characters.count > 25 {
            let modalPopup = ModalPopup(message: "Display name is too long!", delegate: self)
            modalPopup.id = 1
            modalPopup.show()
            return false
        }
        
        
        if validFormat == false{
            let modalPopup = ModalPopup(message: "Only letters and numbers allowed!", delegate: self)
            modalPopup.id = 1
            modalPopup.show()
            return false
        }
        
        return true
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
        if(self.passwordTextField.text != confirmPassword){
            let modalPopup = ModalPopup(message: "Passwords do not match!", delegate: self)
            modalPopup.id = 3
            modalPopup.show()
            return false
        }
        return true
    }
    
    func transitionToConfirm(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConfirmViewController") as! ConfirmViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if (resCode == 200){
            //get the token and store it
            
            var decodedJson : AnyObject
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                singleton.API.setToken(decodedJson["token"] as! String!)
                print("Token was set to \(singleton.API.token)")
            }
            catch (let e) {
                //Error in parsing
                print(e)
            }
            
            transitionToConfirm()
            
            
            
            
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "Could not log you in!", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
        }
    }
    func registerComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if(resCode == 400){
            let modalPopup : ModalPopup = ModalPopup(message: "There was an problem with registering!", delegate: self)
            modalPopup.id = 4
            modalPopup.show()
        }else if (resCode == 200){
            //get the token and store it
            
            //registration complete.. now log in.
            singleton.API.login(self.emailTextField.text, password: self.passwordTextField.text, completion: loginComplete)
            
        }
    }
    
    func transitionToMainTabBar(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        tapForward(okayButton)
        return true
    }
    
    func resignFirstResponders(){
        emailTextField.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    func checkEmailComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        processing = false
        okayButton.setTitle("Next", forState: .Normal)
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if(resCode == 200){
            resignFirstResponders()
            let modalPopup = ModalPopup(message: "Email is already registered!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
        }else if(resCode == 418){
            nextRegisterItem()
        }
        
    }
    func checkDisplayNameComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        processing = false
        okayButton.setTitle("Next", forState: .Normal)
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if(resCode == 200){
            resignFirstResponders()
            let modalPopup = ModalPopup(message: "Display name is already taken!", delegate: self)
            modalPopup.id = 1
            modalPopup.show()
        }else if(resCode == 418){
            nextRegisterItem()
        }

    }
    
    func nextRegisterItem(){
        position = position + 1
        changePosition(position)
    }
    
    func tapForward(sender : UIButton){
        
        if let seeProcessing = processing {
            if (seeProcessing){ //don't let users do it again.
                return
            }
        }
        if(position < 4){
            
            
            var valid : Bool! = true
            if position == 0 {
                valid = validateEmail(self.emailTextField.text)
            }
            
            if position == 1 {
                valid = validateDisplayName(self.displayNameTextField.text)
            }
            
            if position == 2{
                valid = validatePassword(self.passwordTextField.text)
            }
            
            if position == 3{
                valid = validateConfirmPassword(self.confirmPasswordTextField.text)
            }
            
            if let seeValid = valid{
                if(seeValid){
                        if position == 0{
                            okayButton.setTitle("Checking", forState: .Normal)
                            singleton.API.checkEmailExists(self.emailTextField.text, completion: checkEmailComplete)
                            processing = true
                            
                        }else if position == 1{
                            okayButton.setTitle("Checking", forState: .Normal)
                            singleton.API.checkDisplayNameExists(self.displayNameTextField.text, completion: checkDisplayNameComplete)
            
                            processing = true
                        }else if position == 3{
                            //final step
                            okayButton.setTitle("Verifying", forState: .Normal)
                            singleton.API.register(self.emailTextField.text, displayName: self.displayNameTextField.text, password: self.passwordTextField.text, completion: registerComplete)
                            
                            processing = true
                        }else{
                            nextRegisterItem()
                        }
                  
                }else{
                    resignFirstResponders()
                }
            }
            
        }
    }
    
    func tapBack(){
        if let seeProcessing = processing {
            if (seeProcessing){ //don't let users do it again.
                return
            }
        }
        if(position > 0){
            position = position - 1
            changePosition(position)
        }
    }
    

    func loadBackTapView(){
        self.backTapView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - keyboardRect.height - self.okayButton.frame.height - fieldViewHeight))
        self.view.addSubview(backTapView)
        
        let tapBackGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        self.backTapView.addGestureRecognizer(tapBackGestureRecognizer)
    }
    
    
    func keyboardShowing(notification: NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        
        self.keyboardRect = keyboardRect
        self.okayButtonVerticalConstraint.constant = keyboardRect.height
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (finished : Bool) -> Void in
                self.loadBackTapView()
                if let seeKeyboard = self.firstKeyboard{
                    if seeKeyboard {
                        self.changePosition(0)
                        self.firstKeyboard = false
                    }
                }
        })
 
        
    }
    //if you put 1, it will be one above..if you put three you're a bitch
    
    func moveConstraintAboveKeyboard(constraint : NSLayoutConstraint, view : UIView, position : CGFloat!){
        constraint.constant = self.keyboardRect.height + self.okayButton.frame.height + CGFloat(self.fieldViewHeight * CGFloat(position))
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [], animations: { // I KNOW THIS IS GHETTO MEOW
            self.view.layoutIfNeeded()
            view.alpha = 1 - CGFloat(position / 10) * 3
        }, completion: nil)
    }

    
    
    func changePosition(position: Int){
        self.position = position
        //valid positions 0, 1, 2, 3
        if(position == 0){
            self.emailTextField.becomeFirstResponder()
            moveConstraintAboveKeyboard(emailVerticalConstraint, view: emailView, position: 0)
            moveConstraintAboveKeyboard(displayNameVerticalConstraint, view: displayNameView, position: -1)
            moveConstraintAboveKeyboard(passwordVerticalConstraint, view: passwordView, position: -2)
            moveConstraintAboveKeyboard(confirmPasswordVerticalConstraint, view: confirmPasswordView, position: -3)
        }else if (position == 1){
            self.displayNameTextField.becomeFirstResponder()
            moveConstraintAboveKeyboard(emailVerticalConstraint, view: emailView, position: 1)
            moveConstraintAboveKeyboard(displayNameVerticalConstraint, view: displayNameView, position: 0)
            moveConstraintAboveKeyboard(passwordVerticalConstraint, view: passwordView, position: -1)
            moveConstraintAboveKeyboard(confirmPasswordVerticalConstraint, view:confirmPasswordView, position: -2)
        }else if (position == 2){
            self.passwordTextField.becomeFirstResponder()
            moveConstraintAboveKeyboard(emailVerticalConstraint, view: emailView, position: 2)
            moveConstraintAboveKeyboard(displayNameVerticalConstraint, view: displayNameView, position: 1)
            moveConstraintAboveKeyboard(passwordVerticalConstraint, view: passwordView, position: 0)
            moveConstraintAboveKeyboard(confirmPasswordVerticalConstraint, view: confirmPasswordView, position: -1)
        }else if (position == 3){
            self.confirmPasswordTextField.becomeFirstResponder()
            moveConstraintAboveKeyboard(emailVerticalConstraint, view: emailView, position: 3)
            moveConstraintAboveKeyboard(displayNameVerticalConstraint, view: displayNameView, position: 2)
            moveConstraintAboveKeyboard(passwordVerticalConstraint, view:passwordView, position: 1)
            moveConstraintAboveKeyboard(confirmPasswordVerticalConstraint, view: confirmPasswordView, position: 0)
        }
        if position != 3 {
            okayButton.setTitle("Next", forState: .Normal)
        }else{
            okayButton.setTitle("Confirm", forState: .Normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
