//
//  DetailViewController.swift
//  Bulletin
//
//  Created by Pei Liu on 11/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var detailField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // Tap to deactivate the keyboard show up
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .MediumStyle
        return formatter
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        priceField.text = "\(item.price)"
        detailField.text = ""
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
      /*
        let key = item.itemKey
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay*/
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        item.name = nameField.text ?? ""
        
        if let valueText = priceField.text, value = Int(valueText){
            item.price = value
        } else {
            item.price = 0
        }
    }
    
    // Dismissing the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
