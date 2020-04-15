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
        setup()
        self.contentView.backgroundColor = UIColor.red

        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 0
        //设置垂直对齐方式
        label.verticalAlignment = .verticalAlignmentCenter
//        label.text = "dsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasd"
        //支持选择复制
        label.enableCopy = true
        self.layer.masksToBounds = false
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var nib:UINib {
        return UINib(nibName: "RxMVVMTableViewCell", bundle: nil)
    }

    func setup() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu(_:))))
    }

    @objc func showMenu(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }

        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            let copyMenuItem = UIMenuItem(title: "复制", action: #selector(copyTapped))
            menu.menuItems = [copyMenuItem]
            //menu.setTargetRect(senderView.frame, in: superView)
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }

    //复制
    @objc func copyTapped() {
//        let board = UIPasteboard.general
//        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
        self.resignFirstResponder()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyTapped) {
            return true
        }
        return false
    }

}
