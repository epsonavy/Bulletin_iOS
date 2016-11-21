//
//  RegisterViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/20/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIGestureRecognizerDelegate{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        position = 0
        firstKeyboard = true
        //shouldve made it a fucking scrollview
    
        
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        self.view.bringSubviewToFront(titleView) //this guy has to appear first..
        self.view.bringSubviewToFront(okayButton)
        emailTextField.becomeFirstResponder()
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        displayNameTextField.autocorrectionType = UITextAutocorrectionType.No
        
        emailTextField.returnKeyType = UIReturnKeyType.Continue
        displayNameTextField.returnKeyType = UIReturnKeyType.Continue
        passwordTextField.returnKeyType = UIReturnKeyType.Continue
        confirmPasswordTextField.returnKeyType = UIReturnKeyType.Go
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShowing), name: UIKeyboardWillShowNotification, object: nil)
        
        
        emailVerticalConstraint.constant = self.view.frame.height
        displayNameVerticalConstraint.constant = self.view.frame.height
        passwordVerticalConstraint.constant = self.view.frame.height
        confirmPasswordVerticalConstraint.constant = self.view.frame.height
        
        
        okayButton.addTarget(self, action: #selector(tapForward), forControlEvents: .TouchUpInside)
        
        

    }
    
    func validateEmail(email : String!) -> Bool{
        return true
    }
    
    func validateDisplayName(displayName : String!) -> Bool{
        return true
    }
    
    func validatePassword(password: String!) -> Bool{
        return true
    }
    
    
    func validateConfirmPassword(confirmPassword: String!) -> Bool{
        return true
    }
    
    func registerAndLogin(){
        //disable all ui activity here..
        transitionToMainTabBar()
    }
    
    func transitionToMainTabBar(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController") as! MainTabBarController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        tapForward(okayButton)
        return true
    }
    
    func tapForward(sender : UIButton){
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
                    if(position >= 3){
                        registerAndLogin()
                    }else{
                        position = position + 1
                        changePosition(position)
                    }
                  
                }
            }
            
        }
    }
    
    func tapBack(){
        if(position > 0){
            position = position - 1
            changePosition(position)
        }
    }
    

    func loadBackTapView(){
        self.backTapView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - keyboardRect.height - self.okayButton.frame.height))
        self.view.addSubview(backTapView)
        
        let tapBackGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        self.backTapView.addGestureRecognizer(tapBackGestureRecognizer)
    }
    
    
    func keyboardShowing(notification: NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        
        self.keyboardRect = keyboardRect
        
        UIView.animateWithDuration(1, animations: {
            self.okayButtonVerticalConstraint.constant = keyboardRect.height
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
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: { // I KNOW THIS IS GHETTO MEOW
            constraint.constant = self.keyboardRect.height + self.okayButton.frame.height + CGFloat(self.fieldViewHeight * CGFloat(position))
            view.alpha = 1 - CGFloat(position / 10) * 2.5
        }, completion: nil)
    }

    
    
    func changePosition(position: Int){
        self.position = position
        //valid positions 0, 1, 2, 3
        if(position == 0){
            self.emailTextField.becomeFirstResponder()
            moveConstraintAboveKeyboard(emailVerticalConstraint, view: emailView, position: 0)
            moveConstraintAboveKeyboard(displayNameVerticalConstraint, view: displayNameView, position: -1)
            moveConstraintAboveKeyboard(passwordVerticalConstraint, view: passwordView, position: -1)
            moveConstraintAboveKeyboard(confirmPasswordVerticalConstraint, view: confirmPasswordView, position: -1)
        }else if (position == 1){
            self.displayNameTextField.becomeFirstResponder()
            moveConstraintAboveKeyboard(emailVerticalConstraint, view: emailView, position: 1)
            moveConstraintAboveKeyboard(displayNameVerticalConstraint, view: displayNameView, position: 0)
            moveConstraintAboveKeyboard(passwordVerticalConstraint, view: passwordView, position: -1)
            moveConstraintAboveKeyboard(confirmPasswordVerticalConstraint, view:confirmPasswordView, position: -1)
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
