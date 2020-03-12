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

    var item: ProfileCellViewModelProtocol? {
        didSet {
            guard  let item = item as? ProfileAboutCellViewModel else {
                return
            }
            aboutLabel?.text = item.about
            contentLabel?.text = item.count
        }
    }
    
    @IBAction func sutractAction(_ sender: Any) {
        item?.sutractAction()
    }
    
    @IBAction func addAction(_ sender: Any) {
        item?.addAction()
        //item?.unSureAction() //适用于： Cell样式一样，事件不一样
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
