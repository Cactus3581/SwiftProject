//
//  String+SPAdd.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/31.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 计算文本的高度
    func sp_textHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
}

