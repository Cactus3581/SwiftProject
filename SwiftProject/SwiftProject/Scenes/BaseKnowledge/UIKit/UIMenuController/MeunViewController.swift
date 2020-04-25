//
//  MeunViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MeunViewController: BaseViewController {

    @IBOutlet weak var label: MeunLabel!
    @IBOutlet weak var textView: MenuTextView!
    @IBOutlet weak var responsiveView: ResponsiveView!

    @IBOutlet weak var cjLabel1: CJLabel!
    @IBOutlet weak var clLabel2: CJLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        testCLLabel()
        testTextView()
        testResponsiveView()
    }

    func testTextView() {
        let attributeText = NSMutableAttributedString.init(string: "你们有没有听说过半身放远")
        textView.attributedText = attributeText
    }

    func testCLLabel() {
        cjLabel1.backgroundColor = UIColor.green
        cjLabel1.numberOfLines = 0

        cjLabel1.verticalAlignment = .verticalAlignmentCenter
        cjLabel1.text = "dsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasddsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasd"
        cjLabel1.enableCopy = true

        clLabel2.backgroundColor = UIColor.green
        clLabel2.numberOfLines = 0
        clLabel2.verticalAlignment = .verticalAlignmentCenter
        clLabel2.text = "dsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasddsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasd"
        clLabel2.enableCopy = true
        clLabel2.isHidden = true
    }

    func testResponsiveView() {
        responsiveView.isUserInteractionEnabled = true
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
        responsiveView.addGestureRecognizer(longPressGR)
    }

    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {

        let menuView = CJFloatMenuView.share()
        menuView.alpha = 1
        menuView.isHidden = false

        menuView.center = CGPoint(x: 200, y: 300)
        menuView.text = "复制"
//        menuView.show()
        self.view.addSubview(menuView)

//        guard sender.state == .began,
//            let senderView = sender.view,
//            let superView = sender.view?.superview
//            else { return }
//
//        senderView.becomeFirstResponder()

//        let copyMenuItem = UIMenuItem(title: "复制", action: #selector(copyTapped))
//        UIMenuController.shared.menuItems = [copyMenuItem]

        /*
         targetRect：menuController的rframe
         targetView：menu的坐标系根据targetView和targetRect，具体是以targetRect以targetView的左上角为坐标原点

         */
//        菜单最终显示的位置：有两种方式: 一种是以自身的bounds ，还有一种是以父控件的frame
//        UIMenuController.shared.setTargetRect(senderView.bounds, in: senderView)
//        UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
        // 显示菜单
//        UIMenuController.shared.setMenuVisible(true, animated: true)
    }

    @objc func copyTapped() {
        responsiveView.resignFirstResponder()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.cjLabel1.text = "dsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasddsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasd"
            self.clLabel2.text = "dsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasddsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasd"
            self.cjLabel1.setNeedsDisplay()
            self.clLabel2.setNeedsDisplay()


        }) { (context) in

        }
    }
}

class ResponsiveView: UIView {
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
}
