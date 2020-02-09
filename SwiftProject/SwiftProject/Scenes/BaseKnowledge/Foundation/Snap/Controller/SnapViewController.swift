//
//  SnapViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/17.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SnapKit

/*
实际场景实践：
 1. https://lvv.me/posts/2019/12/14_ios_autolayout_priority/
 
 */

protocol a {

}

protocol b {

}

class SnapViewController: BaseViewController,a,b {

//    let v: SnapViewController & a & b = BaseViewController()

    private var bottomConstraint: Constraint?
    private let roundView: SnapView = SnapView.callView as! SnapView

    private let screenMargin: CGFloat = 40.0
    private let view1 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        systemConstraint()
//        displayRoundView()
        practice1_update()
    }

    func practice1_inset() {
        //在描述 view 与 superview 关系时，应该使用 inset，而描述 view 与同一层级的其它 view 时，应该使用 offset。
        let view1 = UIView()
        view1.backgroundColor = UIColor.red
        self.view.addSubview(view1)
        view1.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview().inset(10)
            // 或者直接使用 edges
            $0.edges.equalToSuperview().inset(10)
        }
    }

    func practice1_UIEdgeInsets() {
        //描述 view 跟 superview 之间的边距
        let containerInsets = UIEdgeInsets(top: 100, left: 15, bottom: 25, right:15)
        let view1 = UIView()
        view1.backgroundColor = UIColor.red
        self.view.addSubview(view1)

        let view2 = UIView()
        view2.backgroundColor = UIColor.green
        self.view.addSubview(view2)

        view1.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(containerInsets)
            $0.height.equalTo(100)
        }

        view2.snp.makeConstraints {
            $0.top.equalTo(view1.snp.bottom).offset(5)
            $0.left.bottom.right.equalToSuperview().inset(containerInsets)
        }
    }

    func practice1_update() {

        /*
         修改约束的方法：
         方法1:使用 updateConstraints(推荐)
         方法2:使用一个变量去引用一个约束，然后通过这个引用修改它的 constant
         */

        let view1 = UIView()
        view1.backgroundColor = UIColor.red
        self.view.addSubview(view1)

        let view2 = UIView()
        view2.backgroundColor = UIColor.green
        self.view.addSubview(view2)

        let view3 = UIView()
        view3.backgroundColor = UIColor.blue
        view2.addSubview(view3)

        view1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(50)
            make.width.height.equalTo(150)
            make.top.equalTo(self.view).offset(100)
        }

        view2.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-50)
            make.width.height.equalTo(150)
            make.top.equalTo(self.view).offset(100)
        }

        var constraint: Constraint?
        var constraint1: Constraint?

        view3.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(100)

            // 添加一个 top 约束
//            constraint1 = make.top.equalTo(view1.snp.bottom).offset(-50).priority(.high).constraint // 即使把下面的约束激活，那么该约束也不会无效啊

            constraint1 = make.top.equalTo(view1).offset(50).priority(.high).constraint // 即使把下面的约束激活，那么该约束也不会无效啊

            // 添加一个 top 约束，并获取这个约束，默认就是激活的
//            constraint = make.top.equalTo(view1.snp.top).offset(50).constraint
            constraint = make.top.equalTo(100).constraint
//            make.top.equalTo(2)
        }

        print(constraint?.isActive)
        print(constraint1?.isActive)
//
//        constraint?.activate()

        constraint?.deactivate() //使约束不生效。
        print(constraint?.isActive)
        print(constraint1?.isActive)
    }

    func test() {

        let view1 = UIView()
        view1.backgroundColor = UIColor.red
        self.view.addSubview(view1)

        let view2 = UIView()
        view2.backgroundColor = UIColor.green
        self.view.addSubview(view2)


        let view3 = UIView()
        view3.backgroundColor = UIColor.blue
        view2.addSubview(view3)

        view1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(50)
            make.width.height.equalTo(150)
            make.top.equalTo(self.view).offset(100)
        }

        view2.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-50)
            make.width.height.equalTo(150)
            make.top.equalTo(self.view).offset(100)
        }

        view3.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(100)
            make.top.equalTo(view1.snp.top).offset(20)
        }
    }

    func systemConstraint() {

        view.addSubview(roundView)

        /*

         NSLayoutConstraint

         view1，view1.attribute
         relation(<=>)
         view2，view2.attribute,
         multiplier, c=15


         view1.attribute relation(<=>) multiplier * view2.attribute + c

         */
        roundView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: roundView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: roundView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: roundView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: roundView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)

        // 使约束生效
        self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

//        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

//        horizontalConstraint.isActive = true
//        verticalConstraint.isActive = true
//        widthConstraint.isActive = true
//        heightConstraint.isActive = true
    }


        func displayRoundView() {
            var superView = roundView.superview ?? UIWindow.current
            superView = self.view
            displayRoundView(on: superView)
        }

        func displayRoundView(on view: UIView) {

             if roundView.superview != nil {
                 return
             }

             view.addSubview(roundView)

            roundView.snp.makeConstraints { (make) in
                make.centerX.equalTo(view1)
                make.width.equalTo(50)
                make.height.equalTo(50)
    //            make.width.lessThanOrEqualToSuperview().offset(-10*2)
                make.bottom.equalTo(view1).offset(0).priority(.high)
    //            self.bottomConstraint = make.bottom.equalTo(-100).constraint
            }
    //                     self.bottomConstraint?.activate()
    //                     self.bottomConstraint?.deactivate()
         }
    
}

extension UIWindow {
    public class var current: UIWindow {
        var current: UIWindow?
        let windows = UIApplication.shared.windows
        for window: UIWindow in windows {
            let windowOnMainScreen: Bool = window.screen == UIScreen.main
            let windowIsVisible: Bool = !window.isHidden && window.alpha > 0
            let windowLevelNormal: Bool = window.windowLevel == .normal
            if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                current = window
                break
            }
        }
        assert(current != nil)
        return current!
    }
}
