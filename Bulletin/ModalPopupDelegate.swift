//
//  ModalPopupDelegate.swift
//  Bulletin
//
//  Created by Kevin Trinh on 11/19/16.
//  Copyright © 2016 KPP, Inc. All rights reserved.
//

import UIKit

@objc protocol ModalPopupDelegate: class {
    func modalPopupOkay(sender: ModalPopup)
    func modalPopupClosed(sender: ModalPopup)
}
