//
//  ModalPopup.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/19/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ModalPopup: UIView {
    
    var delegate : ModalPopupDelegate?
    
    var message : String!
    
    var backgroundView : UIView!
    
    var messageView : UIView!
    
    var id : Int!
    
    
    
    func show(){
        print("showing")
        
        let vc = delegate as! UIViewController
        
        vc.view.addSubview(self)
        

        
        UIView.animateWithDuration(0.5, animations: {
            self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            self.messageView.frame.origin.y = vc.view.frame.height / 2 - 75
            }, completion: nil)
    }
    
    func hide(){
        let vc = delegate as! UIViewController
        UIView.animateWithDuration(0.5, animations: {
            self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
            self.messageView.frame.origin.y = vc.view.frame.height + 150
            }, completion: {
                (finished: Bool) -> Void in
                self.close()
                
        })
    }
    
    func close(){
        self.backgroundView.removeFromSuperview()
        self.removeFromSuperview()
        self.messageView.removeFromSuperview()
        if let modelDelegate = self.delegate{
            modelDelegate.modalPopupClosed(self)
        }
    }
    func tapOkay(){
        if let modelDelegate = self.delegate{
            modelDelegate.modalPopupOkay(self)
        }
        hide()
    
    }
    
    init(message: String!, delegate: ModalPopupDelegate!){
        self.delegate = delegate
        self.message = message
        
        let vc = delegate as! UIViewController
        
        self.backgroundView = UIView(frame: vc.view.frame)
        self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)

        self.messageView = UIView(frame: CGRect(x: vc.view.frame.width / 2 - (vc.view.frame.width - 75) / 2, y: -300, width: vc.view.frame.width - 75, height: 150))
        self.messageView.backgroundColor = UIColor.whiteColor()
        self.messageView.layer.cornerRadius = 5
        self.messageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.messageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.messageView.layer.shadowOpacity = 0.2
        self.messageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        let exclamationIcon : UIImageView = UIImageView(frame: CGRect(x: self.messageView.frame.width / 2 - 15, y: 10, width: 30, height: 30))
        exclamationIcon.image = UIImage(named: "exclamation_icon.jpg")
        
        self.messageView.addSubview(exclamationIcon)
        
        let okayButton : FlatButton = FlatButton(frame: CGRect(x: 0, y: self.messageView.frame.height - 40, width: self.messageView.frame.width, height: 40))
        okayButton.setTitle("Okay", forState: .Normal)


        self.messageView.addSubview(okayButton)
        
        
        let messageLabel : UILabel = UILabel(frame: CGRect(x: 10, y: 40, width: self.messageView.frame.width - 20, height: self.messageView.frame.height - 40 - okayButton.frame.height))
        
        messageLabel.text = message
        messageLabel.textAlignment = .Center
        messageLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        messageLabel.font = messageLabel.font.fontWithSize(15)
        
        messageLabel.lineBreakMode = .ByWordWrapping
        messageLabel.numberOfLines = 0
        
        self.messageView.addSubview(messageLabel)

        
        super.init(frame: vc.view.frame)
        
        okayButton.addTarget(self, action: #selector(tapOkay), forControlEvents: .TouchUpInside)
        
        self.addSubview(backgroundView)
        self.addSubview(messageView)
        
        
        let tapClose : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.backgroundView.addGestureRecognizer(tapClose)

        
        
    }
    
    override init(frame: CGRect){

        
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder){

        super.init(coder: aDecoder)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
