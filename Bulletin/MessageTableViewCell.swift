//
//  MessageTableViewCell.swift
//  Bulletin
//
//  Created by Kevin Trinh on 12/4/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
