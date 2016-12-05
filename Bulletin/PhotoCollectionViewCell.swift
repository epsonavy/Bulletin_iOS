//
//  PhotoCollectionViewCell.swift
//  Bulletin
//
//  Created by Pei Liu on 11/17/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var bottomRect: UIView!
    @IBOutlet weak var priceTag: UILabel!
    
    @IBOutlet var userImageView: CircleImageView!
    
    @IBOutlet var details: UILabel!
    @IBOutlet var title: UILabel!
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.hidden = true
            imageView.image = imageToDisplay
            bottomRect.hidden = false
            priceTag.hidden = false
        } else {
            spinner.startAnimating()
            imageView.image = nil
            bottomRect.hidden = true
            priceTag.hidden = true
            
        }
    }
    
    func updateWithUserImageView(image: UIImage?){
        if let imageToDisplay = image{
            userImageView.image = imageToDisplay
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
    }
}
