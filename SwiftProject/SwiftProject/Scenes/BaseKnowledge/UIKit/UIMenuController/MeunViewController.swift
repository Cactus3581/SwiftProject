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
        self.view.backgroundColor = UIColor.init(r: 43, g: 47, b: 54)
        func update(str: Bool, str1: Bool? = nil) {
             if let str1 = str1  {
                 print(str1)
             }
        }

//        let label = CJLabel.init(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 50))
        let label = CJLabel.init()
        label.backgroundColor = UIColor.green
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(190);
        }



        //设置垂直对齐方式
        label.verticalAlignment = .verticalAlignmentCenter
        label.text = "dsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasddsadasdasds盛大的撒的撒打算；来到拉萨开到拉萨看到了卡到拉萨经典款撒的就撒开的adasd"

        //支持选择复制
        label.enableCopy = true



//        label.sizeToFit()







        update(str: true, str1: true)
        update(str: false)


        setup()
        let attributeText = NSMutableAttributedString.init(string: "你们有没有听说过半身放远")
        textView.attributedText = attributeText
    }

    func setup() {
        responsiveView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        responsiveView.addGestureRecognizer(tap)

        let button = UIButton()
        responsiveView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview().offset(-50)
        }
        button.backgroundColor = UIColor.green
        button.setTitleColor(UIColor.white,for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)

//        responsiveView.isUserInteractionEnabled = true
//        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
//        longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
//        responsiveView.addGestureRecognizer(longPressGR)
    }

    @objc func tapClick() {

    }

    @objc func buttonClick() {

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
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
}
