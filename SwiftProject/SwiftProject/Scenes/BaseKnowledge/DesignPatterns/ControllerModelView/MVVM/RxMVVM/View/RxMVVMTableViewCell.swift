//
//  RxMVVMTableViewCell.swift
//  SwiftProject
//
//  Created by Ryan on 2020/4/7.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class RxMVVMTableViewCell: UITableViewCell {

    @IBOutlet weak var label: CJLabel!
    var attributedText: NSAttributedString? {
        didSet {
            guard let attributedText = attributedText else {
                return
            }

            var attributeText = NSMutableAttributedString.init(attributedString: attributedText)
            //字体颜色
            attributeText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSMakeRange(0, attributeText.length))

            //字体大小
            attributeText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, attributeText.length))

            //字间距
            attributeText.addAttribute(NSAttributedString.Key.kern, value: 1, range: NSMakeRange(0, attributeText.length))

            //行间距
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = 1
            attributeText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraph, range: NSMakeRange(0, attributeText.length))

            // 设置背景色
            let config = CJLabelConfigure()
            config.attributes = [
                kCJBackgroundFillColorAttributeName: UIColor.yellow,
                kCJBackgroundLineCornerRadiusAttributeName: 0
            ]
            attributeText = CJLabel.configureAttrString(attributeText, at:  NSMakeRange(0, 10), configure: config)
            label.attributedText = attributeText
            label.flushText()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.red
        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 0
        label.enableCopy = true
        label.verticalAlignment = .verticalAlignmentCenter
        //label.textInsets = UIEdgeInsets(top: CGFloat(kCJPinRoundPointSize), left: 0, bottom: CGFloat(kCJPinRoundPointSize), right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var nib:UINib {
        return UINib(nibName: "RxMVVMTableViewCell", bundle: nil)
    }
}
