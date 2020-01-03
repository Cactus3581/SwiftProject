//
//  AboutCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift

class AboutCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!

    var item: ProfileViewModelItemProtocol? {
        didSet {
            guard  let item = item as? ProfileAboutCellViewModel else {
                return
            }
            aboutLabel?.text = item.about
        }
    }
    
    @IBAction func IBOutletweakvarsubtractButtonUIButtonsubtractAction(_ sender: Any) {


    }
    
    @IBAction func addAction(_ sender: Any) {
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
