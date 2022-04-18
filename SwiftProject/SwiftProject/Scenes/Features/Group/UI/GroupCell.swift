//
//  GroupCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

class GroupCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(indexPath: IndexPath, entity: ChildEntity) {
        self.textLabel?.text = "第\(indexPath.section)区, 第\(indexPath.row)个"
    }

    func setActionHandler(_ handler: ActionHandler) {

    }
}
