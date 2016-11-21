//
//  RequestViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/20/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class RegisterProcessViewController: UIViewController, ModalPopupDelegate {

    @IBOutlet var loadingBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet var loadingBar: UIView!
    
    let singleton : Singleton = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        loadingBarWidthConstraint.constant = 0

        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        
        let email = singleton.email
        let password = singleton.password
        let displayName = singleton.displayName
        

        //the view controller to wait for a request.

        // Do any additional setup after loading the view.
    }
    
    func modalPopupClosed(sender: ModalPopup){
        if sender.id == 1 {
            let nc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
            self.presentViewController(nc, animated: true, completion: nil)
        }
    }
    
    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func goHome(){
        
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        loadingBarWidthConstraint.constant = self.view.frame.width + 20
        UIView.animateWithDuration(5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func finishLoadingBar(){
        loadingBarWidthConstraint.constant = self.view.frame.width + 20
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        finishLoadingBar()
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
