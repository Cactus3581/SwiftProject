//
//  UserProfileTopicView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/29.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTopicView: UIView {

    weak var label: IntrinsicPaddingLabel!

    override init(frame: CGRect) {

        let label = IntrinsicPaddingLabel()
        self.label = label

        super.init(frame: frame)

        self.backgroundColor = UIColor.white

        self.addSubview(label)
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-2)
        }
        label.textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        didSet {
            label.text = title
        }
    }
}

class IntrinsicPaddingLabel: UILabel {

    var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)// 控制字体与控件边界的间隙
    override var intrinsicContentSize: CGSize {
        get {
            let size = super.intrinsicContentSize;
            if (size.width <= 0 || size.height <= 0) {
                return size
            }
            return CGSize(width: size.width + textInsets.left + textInsets.right, height: size.height + textInsets.top +  textInsets.bottom);
        }
    }
}
