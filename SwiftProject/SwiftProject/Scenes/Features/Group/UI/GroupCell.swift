//
//  GroupCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

class GroupCell: UITableViewCell {

    func setContent(row: Int) {
        self.textLabel?.text = "\(row)"
    }

    func setActionHandler(_ handler: ActionHandler) {

    }
}
