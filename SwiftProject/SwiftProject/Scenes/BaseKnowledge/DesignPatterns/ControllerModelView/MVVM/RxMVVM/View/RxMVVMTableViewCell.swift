//
//  RxMVVMTableViewCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/7.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class RxMVVMTableViewCell: UITableViewCell {

    @IBOutlet weak var label: CJLabel!
    var attributedText: NSAttributedString? {
        didSet {
            label.attributedText = attributedText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.red
        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 0
        label.verticalAlignment = .verticalAlignmentCenter
        label.enableCopy = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var nib:UINib {
        return UINib(nibName: "RxMVVMTableViewCell", bundle: nil)
    }
}
