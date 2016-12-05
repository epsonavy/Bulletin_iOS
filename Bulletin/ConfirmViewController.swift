//
//  ConfirmViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/20/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ModalPopupDelegate {
    @IBOutlet var profileImageView: CircleImageView!
    
    let imagePicker = UIImagePickerController()
    
    let singleton = Singleton.sharedInstance

    @IBAction func proceedToMainTab(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RetrieveProfileViewController") as! RetrieveProfileViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //dont let the user go back
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        let changePictureTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePicture))
        
        profileImageView.userInteractionEnabled = true
        
        profileImageView.addGestureRecognizer(changePictureTapGesture)
        // Do any additional setup after loading the view.
    }
    func changePicture(gestureRecognizer: UIGestureRecognizer){
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func modalPopupOkay(sender: ModalPopup) {
        
    }
    
    func modalPopupClosed(sender: ModalPopup) {
        if sender.id == 0{
            profileImageView.image = UIImage(named: "name_icon.png")
        }
    }
    
    func checkUpdateComplete(response: NSURLResponse?, data: NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        if (resCode == 200){
            let modalPopup : ModalPopup = ModalPopup(message: "Image upload successful!", delegate: self)
            modalPopup.id = 1
            modalPopup.show()
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with updating your profile!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
        }
    }
    
    func checkUploadComplete(response: NSURLResponse?, data:NSData?, error: NSError?){
        let responseHTTP = response as! NSHTTPURLResponse!
        let resCode = responseHTTP.statusCode
        
        print(resCode)
        
        if (resCode == 200){
            //get the token and store it
            
            var decodedJson : AnyObject
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                singleton.profilePicture = decodedJson["url"] as! String!
            }
            catch (let e) {
                //Error in parsing
                print(e)
            }
            singleton.API.updateProfilePicture(singleton.profilePicture, completion: checkUpdateComplete)
            
            
        }else{
            let modalPopup : ModalPopup = ModalPopup(message: "There was a problem with uploading!", delegate: self)
            modalPopup.id = 0
            modalPopup.show()
            
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .ScaleAspectFill
            profileImageView.image = image
            singleton.API.uploadImage(profileImageView.image, completion: checkUploadComplete)
        }
        dismissViewControllerAnimated(true, completion: nil)
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
