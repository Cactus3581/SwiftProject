//
//  AboutCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel?
    
    var item: ProfileViewModelItemProtocol? {
        didSet {
            guard  let item = item as? ProfileViewModelAboutCellViewModel else {
                return
            }
            aboutLabel?.text = item.about
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
