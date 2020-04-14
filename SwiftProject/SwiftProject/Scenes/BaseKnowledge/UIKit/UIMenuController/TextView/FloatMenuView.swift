//
//  FloatMenuView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/13.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class FloatMenuView: UIView {

    static let shared = FloatMenuView()

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
