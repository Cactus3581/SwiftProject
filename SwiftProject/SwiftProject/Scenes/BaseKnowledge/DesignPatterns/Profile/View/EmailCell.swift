//
//  EmailCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class EmailCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel?
    
    var item: ProfileViewModelItemProtocol? {
        didSet {
            guard let item = item as? ProfileEmailCellViewModel else {
                return
            }
            
            emailLabel?.text = item.email
        }
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
