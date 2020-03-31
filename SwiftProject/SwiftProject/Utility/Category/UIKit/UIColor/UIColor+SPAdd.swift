//
//  UIColor+SPAdd.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/31.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    /// 背景灰色 f8f9f7
    class func sp_globalBackgroundColor() -> UIColor {
        return UIColor(r: 248, g: 249, b: 247)
    }
}
