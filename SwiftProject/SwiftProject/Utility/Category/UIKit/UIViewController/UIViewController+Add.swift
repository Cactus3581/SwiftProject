//
//  UIViewController+Add.swift
//  SwiftProject
//
//  Created by Ryan on 2020/8/6.
//  Copyright © 2020 cactus. All rights reserved.
//

extension UIViewController {

    func addChildController(_ child: UIViewController) {
        self.addChild(child)
        view.addSubview(child.view)
        let frame = view.frame
        print("frame.size.width \(frame)")
        child.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height-40)
//        child.view.frame = view.frame
        child.didMove(toParent: self)// 通知子视图控制器已经被加入到父视图控制器中
    }

    func removeChildController() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)// 通知子视图控制器将要从父视图控制器中移除
        view.removeFromSuperview()
        self.removeFromParent()
    }
}
