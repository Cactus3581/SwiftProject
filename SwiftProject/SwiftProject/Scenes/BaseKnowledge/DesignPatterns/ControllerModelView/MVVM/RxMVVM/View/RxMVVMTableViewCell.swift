//
//  RxMVVMTableViewCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/7.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class RxMVVMTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: MenuTextView!
    var attributedText: NSAttributedString? {
        didSet {
            textView.attributedText = attributedText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        textView.backgroundColor = UIColor.lightGray
        textView.layoutManager.allowsNonContiguousLayout = true

        textView.isEditable = false
//        textView.isScrollEnabled = false // 写了计算高度不对
        //内容缩进为0（去除左右边距）
        self.textView.textContainer.lineFragmentPadding = 0
        //文本边距设为0（去除上下边距）
        self.textView.textContainerInset = .zero
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
