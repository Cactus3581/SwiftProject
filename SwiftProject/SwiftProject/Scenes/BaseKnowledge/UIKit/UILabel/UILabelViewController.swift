//
//  UILabelViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2021/2/25.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit
import SnapKit

class UILabelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    func initializeUI() {
        /*
          ContentHuggingPriority：抗拉伸属性，默认250，表示当前的Label的内容不想被拉伸
          ContentCompressionResistancePriority：抗压缩属性，默认750，表示当前的Label的内容不想被收缩
          需要考虑两种情况，
         1. 左右两边数据都不足的时候，谁拉伸？
         2. 左右两边数据都充足的时候，谁收缩？
         */
    }
}
