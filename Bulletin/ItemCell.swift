//
//  ItemCell.swift
//  Bulletin
//
//  Created by Pei Liu on 11/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
    }
}
