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
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        Singleton.sharedInstance.photoStore.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recnet photos.\n")
                    self.photoDataSource.photos = photos
                case let .Failure(e):
                    self.photoDataSource.photos.removeAll()
                    print("Error: \(e)")
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destinationViewController as! PhotoInfoViewController
                destinationVC.photo = photo
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideNavigationBar(hide: Bool){
        if (navigationBar == nil){
            print("navigationBar is nil")
        }
    }
}
