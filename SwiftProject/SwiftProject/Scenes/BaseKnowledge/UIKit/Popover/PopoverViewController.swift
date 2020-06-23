//
//  PopoverViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/6/9.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class PopoverViewController: BaseViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        toShowPopOver()
    }

    func toShowPopOver() {
        let popoverContentVC = UIViewController()
        popoverContentVC.modalPresentationStyle = .popover
        if let popover = popoverContentVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: 50, y: 120, width: 1, height: 1) // 箭头所指向的矩形区域rect
            popoverContentVC.preferredContentSize = CGSize(width: 100, height: 200)// 设置尺寸
            popover.permittedArrowDirections = .up
            popover.delegate = self
        }
        self.present(popoverContentVC, animated: true, completion: nil)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
