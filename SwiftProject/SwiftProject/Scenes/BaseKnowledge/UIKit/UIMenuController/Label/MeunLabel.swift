//
//  MeunLabel.swift
//  SwiftProject
//
//  Created by Ryan on 2020/4/8.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MeunLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
        let board = UIPasteboard.general
        board.string = text
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
