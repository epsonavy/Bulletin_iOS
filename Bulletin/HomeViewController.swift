//
//  HomeViewController.swift
//  Bulletin
//
//  Created by Kevin Trinh, Pei Liu on 10/24/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class HomeViewController : UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var navigationBar: GrayBarView!
    @IBOutlet weak var navigationBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var universityLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var refreshItemsControl : UIRefreshControl!
    
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        
        
        refreshItems()
        refreshItemsControl = UIRefreshControl()
        
        refreshItemsControl.addTarget(self, action: #selector(refreshItems), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshItemsControl)
        loadEduEmail()
    
    }
    
    func loadEduEmail() {
        if let email = Singleton.sharedInstance.email {
            print(email)
            let eduEmail = email.componentsSeparatedByString("@")[1]
            let abbr = eduEmail.componentsSeparatedByString(".")[0]
        
            switch abbr {
            // Only add Bay Area University
            case "sjsu": universityLabel.text = "San Jose State University"
            case "berkeley": universityLabel.text = "UC Berkeley"
            case "ucdavis": universityLabel.text = "UC Davis"
            case "ucsd" : universityLabel.text = "UC San Diego"
            case "ucla" : universityLabel.text = "UC Los Angeles"
            case "ucsb" : universityLabel.text = "UC Santa Barbara"
            case "sfsu" : universityLabel.text = "San Francisco State University"
            default : universityLabel.text = "San Jose State University"
            }
        }
    }
    
    func refreshItems(){
        Singleton.sharedInstance.photoStore.getItems() {
            (photosResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recnet photos.\n")
                    self.photoDataSource.photos = (photos as! [ItemPhoto]).sort{$0.expiration.intValue > $1.expiration.intValue}
                case let .Failure(e):
                    self.photoDataSource.photos.removeAll()
                    print("Error: \(e)")
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0))
                self.refreshItemsControl.endRefreshing()
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destinationViewController as! PhotoInfoViewController
                destinationVC.photo = photo as! ItemPhoto
                destinationVC.store = Singleton.sharedInstance.photoStore
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        Singleton.sharedInstance.photoStore.fetchImageForPhoto(photo) { (result) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath)
                    as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                }
            }
        }
    }
    func
        collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set cell width to 100%
        return CGSize(width: self.view.frame.width - 15, height: self.view.frame.height / 2.35)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideNavigationBar(hide: Bool){
        if (navigationBar == nil){
            print("navigationBar is nil")
        }
    }
}
