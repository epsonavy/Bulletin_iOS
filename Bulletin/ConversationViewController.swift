//
//  ConversationViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var inputViewVerticalConstraint: NSLayoutConstraint!

    @IBOutlet var inputViewBorder: UIView!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var withLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    
    
    var conversation : Message!
    
    let refreshMessagesControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("peter is so gay")
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        // Do any additional setup after loading the view.
        self.messageTableView.separatorStyle = .None
        
        refreshMessagesControl.addTarget(self, action: #selector(refreshMessages), forControlEvents: UIControlEvents.ValueChanged)
        
        self.messageTableView.addSubview(refreshMessagesControl)
        
        withLabel.text = "with \(conversation.name)"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShowing), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHiding), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardShowing(notification: NSNotification){
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect = keyboardFrame.CGRectValue()
        
        
        inputViewVerticalConstraint.constant = keyboardRect.height - self.tabBarController!.tabBar.frame.height
        
        UIView.animateWithDuration(0.75, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardHiding(notification: NSNotification){
        inputViewVerticalConstraint.constant = 0
        UIView.animateWithDuration(0.75, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func refreshMessages(){
        
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
