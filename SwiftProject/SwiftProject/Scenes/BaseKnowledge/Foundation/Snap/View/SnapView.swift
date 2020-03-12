//
//  SnapView.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/17.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class SnapView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var callView: UIView {
        return Bundle.main.loadNibNamed("SnapView", owner: nil, options: nil)?[0] as! SnapView
    }
}
