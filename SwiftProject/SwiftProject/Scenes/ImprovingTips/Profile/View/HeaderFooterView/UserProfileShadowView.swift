//
//  UserProfileShadowView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/30.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileShadowView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sp_setShadowPath(direction: .bottom, shadowColor: UIColor.init(red: 31/255.0, green: 35/255.0, blue: 41/255.0, alpha: 0.1), shadowOpacity: 1, shadowRadius: 10, shadowPathOffset: 6)
    }
}
