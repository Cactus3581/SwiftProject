//
//  CollectionViewCell.swift
//  SwiftProject
//
//  Created by Ryan on 2020/8/20.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {

    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
