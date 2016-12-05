//
//  ConversationViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/23/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet var inputViewVerticalConstraint: NSLayoutConstraint!

    @IBOutlet var inputViewBorder: UIView!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var withLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    
    
    var conversation : Message!
    
    
    var messages = [MessageEntity]()
    
    let singleton = Singleton.sharedInstance
    
    var sendingMessage : Bool!
    
    
    let refreshMessagesControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendingMessage = false
        print("peter is so gay")
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        // Do any additional setup after loading the view.
        self.messageTableView.separatorStyle = .None
        
        self.inputTextField.delegate = self
        self.inputTextField.returnKeyType = .Send
        
        
        refreshMessagesControl.addTarget(self, action: #selector(refreshMessages), forControlEvents: UIControlEvents.ValueChanged)
        
        self.messageTableView.addSubview(refreshMessagesControl)
        
        withLabel.text = "with \(conversation.name)"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignFirstResponders))
        self.messageTableView.addGestureRecognizer(tapGestureRecognizer)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardShowing), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHiding), name: UIKeyboardWillHideNotification, object: nil)
        
        refreshMessages()
        
    }
    
    func resignFirstResponders(){
        self.inputTextField.resignFirstResponder()
    }
 
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
        cell.nameLabel.text = messages[indexPath.row].name
        cell.timestampLabel.text = dateFormatter.stringFromDate(messages[indexPath.row].timestamp)
        cell.messageTextView.text = messages[indexPath.row].message
        return cell
    }
    

    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()


    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        let size: CGSize = inputTextField.font!.sizeOfString(messages[indexPath.row].message, constrainedToWidth: Double(self.view.frame.width - 20))
        print(size.height)
        return 45 + size.height
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
    
    func processMessages(data: NSData){
        self.messages.removeAll()
        
        
        var decodedJson : AnyObject
        do {
            decodedJson = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        let messages = decodedJson as! NSArray
        for var message in messages{
            let userId = message["userId"] as! String
            var from : String
            if(userId == singleton.userId){
                from = singleton.displayName
            }else{
                from = conversation.name
            }
            
            let timestamp = message["timestamp"] as! NSNumber
            let messageIndex = message["messageIndex"] as! Int
            let content = message["message"] as! String
            
            self.messages.append(MessageEntity(name: from, timestamp: timestamp, message: content, messageIndex: messageIndex))
            
        
            
        }
        }catch(let e){
            print(e)
        }
        self.messageTableView.reloadData()
        
    }
    
    func checkMessageSendComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        sendingMessage = false
        guard let resHTTP = response as! NSHTTPURLResponse! else{
            return
        }
        
        if resHTTP.statusCode == 200{
            refreshMessages()
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if sendingMessage == true {
            return true
        }
        
        if let messageSend = textField.text {
            if messageSend.characters.count > 0 {
            sendingMessage = true
            singleton.API.sendMessage(conversation.conversationId, message: messageSend, completion: checkMessageSendComplete)
            
            textField.text = ""
            
            }
        }
        return true
        

    }
    
    
    func checkMessagesComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        refreshMessagesControl.endRefreshing()
        guard let resHTTP = response as! NSHTTPURLResponse! else{
            return
        }
        
        guard let jsonData = data else{
            return
        }
        if resHTTP.statusCode == 200 {
            processMessages(jsonData)
        }
        
    }
    
    func refreshMessages(){
        singleton.API.getAllMessages(conversation.conversationId, completion: checkMessagesComplete)
        
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
