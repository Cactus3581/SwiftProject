//
//  GroupHeader.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

class GroupHeader: UITableViewHeaderFooterView {

    var handler: ActionHandler?
    var entity: ParentEntity?
    var section: Int?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let button = UIButton(type: .custom)
        self.contentView.addSubview(button)
        button.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func tap() {
        guard let entity = entity, let section = section else { return }
        handler?.expand(entity: entity, section: section)
    }

    func setContent(section: Int, entity: ParentEntity) {
        self.entity = entity
        self.section = section
        self.textLabel?.text = "第\(section)区"
    }

    func setActionHandler(_ handler: ActionHandler) {
        self.handler = handler
    }
}
