//
//  MeunViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MeunViewController: BaseViewController {

    @IBOutlet weak var responsiveView: ResponsiveView!
    @IBOutlet weak var label: MeunLabel!
    @IBOutlet weak var textView: MenuTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        func update(str: Bool, str1: Bool? = nil) {
             if let str1 = str1  {
                 print(str1)
             }
        }

        update(str: true, str1: true)
        update(str: false)


//        setup() b
        let attributeText = NSMutableAttributedString.init(string: "白日依山尽，黄河入海流")
        textView.attributedText = attributeText
    }

    func setup() {
        responsiveView.isUserInteractionEnabled = true
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
        responsiveView.addGestureRecognizer(longPressGR)
    }

    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }

        senderView.becomeFirstResponder()

        let copyMenuItem = UIMenuItem(title: "复制", action: #selector(copyTapped))
        UIMenuController.shared.menuItems = [copyMenuItem]

        /*
         targetRect：menuController的rframe
         targetView：menu的坐标系根据targetView和targetRect，具体是以targetRect以targetView的左上角为坐标原点

         */


//        菜单最终显示的位置：有两种方式: 一种是以自身的bounds ，还有一种是以父控件的frame
        UIMenuController.shared.setTargetRect(senderView.bounds, in: senderView)
//        UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
        // 显示菜单
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }

    @objc func copyTapped() {
        responsiveView.resignFirstResponder()
    }
}

class ResponsiveView: UIView {
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
